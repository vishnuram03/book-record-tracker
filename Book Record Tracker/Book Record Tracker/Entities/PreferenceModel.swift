import Foundation

final class PreferenceModel: DatabaseModel {
    static let tableName = "preferences"
    static let primaryKey = "id"

    var id: Int?
    var userId: Int
    var preferredGenres: String
    var preferredAuthors: String
    var preferredSize: String

    var genresArray: [String] {
        preferredGenres
            .split(separator: ",")
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    var authorsArray: [String] {
        preferredAuthors
            .split(separator: ",")
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    init(
        id: Int? = nil,
        userId: Int,
        preferredGenres: String = "",
        preferredAuthors: String = "",
        preferredSize: String = ""
    ) {
        self.id = id
        self.userId = userId
        self.preferredGenres = preferredGenres
        self.preferredAuthors = preferredAuthors
        self.preferredSize = preferredSize
    }

    static func columnDefinitions() -> [(String, DatabaseColumnType)] {
        [
            ("id", .integer),
            ("user_id", .integer),
            ("preferred_genres", .text),
            ("preferred_authors", .text),
            ("preferred_size", .text)
        ]
    }

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "user_id": userId,
            "preferred_genres": preferredGenres,
            "preferred_authors": preferredAuthors,
            "preferred_size": preferredSize
        ]

        if let id {
            dict["id"] = id
        }

        return dict
    }

    static func fromDictionary(_ dict: [String: Any]) -> PreferenceModel? {
        guard
            let id = dict["id"] as? Int,
            let userId = dict["user_id"] as? Int
        else {
            return nil
        }

        return PreferenceModel(
            id: id,
            userId: userId,
            preferredGenres: dict["preferred_genres"] as? String ?? "",
            preferredAuthors: dict["preferred_authors"] as? String ?? "",
            preferredSize: dict["preferred_size"] as? String ?? ""
        )
    }
}
