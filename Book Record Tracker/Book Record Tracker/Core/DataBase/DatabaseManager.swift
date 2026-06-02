//
//  DatabaseManager.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 28/05/26.
//

import UIKit
import SQLite3

private let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

class DatabaseManager {
    
    static let shared = DatabaseManager()
    private var db : OpaquePointer?
    
    private init(){
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let databaseUrl = documentsUrl.appendingPathComponent("BookTrackerDatabase.sqlite3").path
        
        openDatabase(databaseUrl)
        createTables()
    }
    
    func openDatabase(_ databaseUrl: String) {
        if sqlite3_open(databaseUrl, &db) == SQLITE_OK {
            print("Database opened successfully")
            print("Location: \(databaseUrl)")
        } else {
            print("Failed to open database")
            printDatabaseError()
        }
    }
    
    func closeDatabase() {
        if sqlite3_close(db) == SQLITE_OK {
            print("Database closed successfully")
        } else {
            print("Failed to close database")
        }
    }
    
    func createTables() {
        createTable(for: UserModel.self)
        createTable(for: BookModel.self)
        createTable(for: UserBookModel.self)
        createTable(for: ReadingSessionModel.self)
        createTable(for: ChallengeModel.self)
        createTable(for: PreferenceModel.self)
        createTable(for: RecommendationCacheModel.self)
        
    }
    private func createTable<T : DatabaseModel>(for model: T.Type) -> Bool {
        let tableName = model.tableName
        let columns = model.columnDefinitions()
        
        var columnDefinition: [String] = []
        
        for (columnName, columnType) in columns {
            if columnName == model.primaryKey {
                columnDefinition.append("\(columnName) INTEGER PRIMARY KEY AUTOINCREMENT" )
            }
            else{
                columnDefinition.append("\(columnName) \(columnType.sqlType)")
            }
        }
        let columnString = columnDefinition.joined(separator: ", ")
        
        let createTableSql = "CREATE TABLE IF NOT EXISTS \(tableName) (\(columnString));"
        return executeSQL(createTableSql)
    }
    
    func insert<T: DatabaseModel>(_ model: T) -> Bool {
        let tableName = T.tableName
        let dictionary = model.toDictionary()
        
        return insertModel( dictionary, tableName: tableName, primaryKey : T.primaryKey)
    }
    func insertModel(_ dictionary: [String:Any] , tableName: String, primaryKey: String) -> Bool{
        let dict = dictionary
        let sortedKeys = dict.keys
            .filter { $0 != primaryKey }
            .sorted()
        let columns = sortedKeys.joined(separator: ", ")
        let placeHolder = sortedKeys.map{_ in "?"}.joined(separator: ", ")
        let insertSql = "INSERT INTO \(tableName) (\(columns)) VALUES (\(placeHolder));"
        
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(db,insertSql,-1,&statement, nil) == SQLITE_OK else{
            print("Falied to Execute the insert query")
            printDatabaseError()
            return false
        }
        var index: Int = 1
        for key in sortedKeys{
            let value = dict[key] ?? nil
            bindValue(value, to: statement, at: index)
            index += 1
        }
        let result = sqlite3_step(statement) == SQLITE_DONE
        sqlite3_finalize(statement)
        
        if result {
            let lastId = sqlite3_last_insert_rowid(db)
            print("Last inserted id: \(lastId)")
        }
        else{
            print("Insert Falied")
            printDatabaseError()
        }
        return result
    }
    
    func lastInsertedId() -> Int {
            return Int(sqlite3_last_insert_rowid(db))
        }
    
    func fetchAll<T: DatabaseModel>(
        _ modelType: T.Type
    ) -> [T] {
        
        return fetchAllFromTable(
            tableName: T.tableName,
            modelType: modelType
        )
    }
    
    func fetchAllFromTable<T: DatabaseModel>(
        tableName: String,
        modelType: T.Type
    ) -> [T] {
        
        var results: [T] = []
        
        let selectSQL = """
        SELECT * FROM \(tableName);
        """
        
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(
            db,
            selectSQL,
            -1,
            &statement,
            nil
        ) == SQLITE_OK else {
            
            return results
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            
            let columnCount = sqlite3_column_count(statement)
            
            var dict: [String: Any] = [:]
            
            for i in 0..<columnCount {
                
                let columnName = String(
                    cString: sqlite3_column_name(statement, i)
                )
                
                let value = getColumnValue(
                    from: statement,
                    at: Int(i)
                )
                
                dict[columnName] = value
            }
            
            if let model = modelType.fromDictionary(dict) {
                results.append(model)
            }
        }
        
        sqlite3_finalize(statement)
        
        return results
    }
    
    
    func update<T: DatabaseModel>(_ model: T) -> Bool {
        guard let modelId = model.id else {
            return false
        }
        
        return updateDictionary(
            model.toDictionary(),
            tableName: T.tableName,
            primaryKey: T.primaryKey,
            id: modelId
        )
    }
    func updateDictionary(_ dictionary: [String: Any], tableName: String, primaryKey: String, id: Int) -> Bool{
        
        let sortedKeys = dictionary.keys
            .filter { $0 != primaryKey }
            .sorted()
        
        let setClause = sortedKeys.map {"\($0) = ?"}.joined(separator: ", ")
        
        let updateSQL = "UPDATE \(tableName) SET \(setClause) WHERE \(primaryKey) = ?;"
        
        var statement : OpaquePointer?
        
        guard sqlite3_prepare_v2(db,updateSQL,-1,&statement, nil) == SQLITE_OK else{
            print("Update prepare failed")
            return false
        }
        var index : Int = 1
        for key in sortedKeys {
            bindValue(dictionary[key], to: statement, at: index)
            index += 1
        }
        
        sqlite3_bind_int(statement,Int32(index), Int32(id))
        
        let result = sqlite3_step(statement) == SQLITE_DONE
        
        sqlite3_finalize(statement)
        
        return result
    }
    
    func delete<T: DatabaseModel>(
        _ modelType: T.Type,
        id: Int64
    ) -> Bool {
        
        return deleteFromTable(
            tableName: T.tableName,
            primaryKey: T.primaryKey,
            id: id
        )
    }
    
    func deleteFromTable(
        tableName: String,
        primaryKey: String,
        id: Int64
    ) -> Bool {
        
        let deleteSQL = """
        DELETE FROM \(tableName)
        WHERE \(primaryKey) = ?;
        """
        
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(
            db,
            deleteSQL,
            -1,
            &statement,
            nil
        ) == SQLITE_OK else {
            
            return false
        }
        
        sqlite3_bind_int64(statement, 1, id)
        
        let result = sqlite3_step(statement) == SQLITE_DONE
        
        sqlite3_finalize(statement)
        
        return result
    }
    
    func searchWhere<T: DatabaseModel>(
        _ modelType: T.Type,
        where conditions: [String: Any]
    ) -> [T] {

        let tableName = T.tableName

        var results: [T] = []
        let sortedKeys = conditions.keys.sorted()

        let whereClause = sortedKeys
            .map { "\($0) = ?" }
            .joined(separator: " AND ")

        let sql = """
        SELECT * FROM \(tableName)
        WHERE \(whereClause);
        """

        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(
            db,
            sql,
            -1,
            &statement,
            nil
        ) == SQLITE_OK else {

            print("Failed to prepare statement")
            return results
        }

        defer {
            sqlite3_finalize(statement)
        }

        var index: Int = 1

        for key in sortedKeys {
            let value = conditions[key]
            bindValue(value,
                      to: statement,
                      at: index)
            index += 1
        }

        while sqlite3_step(statement) == SQLITE_ROW {

            var dict: [String: Any] = [:]

            for i in 0..<sqlite3_column_count(statement) {

                let name = String(
                    cString: sqlite3_column_name(statement, i)
                )

                dict[name] =
                    getColumnValue(
                        from: statement,
                        at: Int(i)
                    )
            }

            if let model = T.fromDictionary(dict) {
                results.append(model)
            }
        }

        return results
    }
    
    private func executeSQL(_ sql: String) -> Bool {
        var errorMessage: UnsafeMutablePointer<CChar>?
        let result = sqlite3_exec(db,sql,nil,nil,&errorMessage)
        
        if result == SQLITE_OK{
                print("SQL executed Successfully")
            return true
        }
        else{
            print("SQL execution failed")
            if let error = errorMessage {
                print("     Error: \(String(cString: error))")
                sqlite3_free(error)
            }
        }
        return false
    }
    private func bindValue(_ value: Any?, to statement: OpaquePointer?, at index: Int){
        let indexes = Int32(index)
        guard let value = value else{
            sqlite3_bind_null(statement, indexes)
            return
        }
        
        switch value {
        case let intValue as Int:
            sqlite3_bind_int64(statement, indexes, Int64(intValue))
        case let int64Value as Int64:
            sqlite3_bind_int64(statement, indexes, int64Value)
        case let doubleValue as Double:
            sqlite3_bind_double(statement, indexes, doubleValue)
        case let stringValue as String:
            sqlite3_bind_text(statement, indexes, stringValue, -1, SQLITE_TRANSIENT)
        case let boolValue as Bool:
            sqlite3_bind_int(statement, indexes, boolValue ? 1 : 0)
        default:
            let stringValue = "\(value)"
            sqlite3_bind_text(statement, indexes, stringValue, -1, nil)
        }
    }
    func getColumnValue(from statement: OpaquePointer?, at index: Int) -> Any? {
        
        let indexes = Int32(index)
        let type = sqlite3_column_type(statement, indexes)
        
        switch type {
        case SQLITE_INTEGER:
            return Int(sqlite3_column_int64(statement, indexes))
        case SQLITE_FLOAT:
            return sqlite3_column_double(statement, indexes)
        case SQLITE_TEXT:
            if let cString = sqlite3_column_text(statement, indexes) {
                return String(cString: cString)
            }
            return nil
        default:
            return nil
        }
    }
    
    func printDatabaseError() {
        if let errorPointer = sqlite3_errmsg(db) {
            let errorMessage = String(cString: errorPointer)
            print("   SQLite Error: \(errorMessage)")
        }
    }
}
