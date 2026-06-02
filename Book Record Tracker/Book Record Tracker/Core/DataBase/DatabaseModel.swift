//
//  DatabaseModel.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 28/05/26.
//

protocol DatabaseModel {
    static var tableName: String { get }
    static var primaryKey: String { get }
    var id: Int? { get set }

    static func columnDefinitions() -> [(String, DatabaseColumnType)]
    static func fromDictionary(_ dict: [String: Any]) -> Self?
    func toDictionary() -> [String: Any]
}
