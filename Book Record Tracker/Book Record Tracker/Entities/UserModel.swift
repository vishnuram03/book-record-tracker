import Foundation

final class UserModel: DatabaseModel {

    static let tableName = "users"
    static let primaryKey = UserColumn.userId

    var id: Int?
    var username: String
    var emailId: String
    var password: String

    init(id: Int? = nil, username: String, emailId: String, password: String) {
        self.id = id
        self.username = username
        self.emailId = emailId
        self.password = password
    }

    enum UserColumn {
        static let userId = "user_id"
        static let username = "username"
        static let emailId = "email_id"
        static let password = "password"
    }

    static func columnDefinitions() -> [(String, DatabaseColumnType)] {
        return [
            (UserColumn.userId, .integer),
            (UserColumn.username, .text),
            (UserColumn.emailId, .text),
            (UserColumn.password, .text)
        ]
    }

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            UserColumn.username: username,
            UserColumn.emailId: emailId,
            UserColumn.password: password
        ]

        if let id {
            dict[UserColumn.userId] = id
        }

        return dict
    }

    static func fromDictionary(_ dict: [String: Any]) -> UserModel? {
        guard
            let id = dict[UserColumn.userId] as? Int,
            let username = dict[UserColumn.username] as? String,
            let emailId = dict[UserColumn.emailId] as? String,
            let password = dict[UserColumn.password] as? String
        else {
            return nil
        }

        return UserModel(id: id, username: username, emailId: emailId, password: password)
    }
}
