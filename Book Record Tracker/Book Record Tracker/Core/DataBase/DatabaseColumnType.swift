//
//  DatabaseColumnType.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 28/05/26.
//

enum DatabaseColumnType {
    case integer
    case text
    case double
    case boolean
    case real
    case blob
    
    var sqlType: String {
        switch self {
            case .integer:
            return "INTEGER"
        case .text:
            return "TEXT"
        case .double:
            return "DOUBLE"
        case .boolean:
            return "BOOLEAN"
        case .real:
            return "REAL"
        case .blob:
            return "BLOB"
        }
    }
}
