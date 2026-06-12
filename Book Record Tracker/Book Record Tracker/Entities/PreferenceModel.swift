import Foundation

final class PreferenceModel: DatabaseModel {
    static let tableName = "preferences"
    static let primaryKey = PreferenceColumn.preferenceId

    var id: Int?
    var userId: Int
    var preferredGenres: [String]
    var preferredSize: String
    var preferredAuthor: [String]

    init(
        id: Int? = nil,
        userId: Int,
        preferredGenres: [String] = [],
        preferredSize: String = "",
        preferredAuthor : [String] = []
    ) {
        self.id = id
        self.userId = userId
        self.preferredGenres = preferredGenres
        self.preferredSize = preferredSize
        self.preferredAuthor = preferredAuthor
    }

    enum PreferenceColumn {
        static let preferenceId = "preference_id"
        static let userId = "user_id"
        static let preferredGenres = "preferred_genres"
        static let preferredSize = "preferred_size"
        static let preferredAuthor = "preferred_author"
    }

    static func columnDefinitions() -> [(String, DatabaseColumnType)] {
        return [
            (PreferenceColumn.userId, .integer),
            (PreferenceColumn.preferredGenres, .text),
            (PreferenceColumn.preferredSize, .text),
            (PreferenceColumn.preferredAuthor, .text)
        ]
    }

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            PreferenceColumn.userId: userId,
            PreferenceColumn.preferredGenres: preferredGenres.joined(separator: ","),
            PreferenceColumn.preferredSize: preferredSize,
            PreferenceColumn.preferredAuthor: preferredAuthor.joined(separator: ",")
        ]

        if let id {
            dict[PreferenceColumn.preferenceId] = id
        }

        return dict
    }

    static func fromDictionary(_ dict: [String: Any]) -> PreferenceModel? {
        guard
            let id = dict[PreferenceColumn.preferenceId] as? Int,
            let userId = dict[PreferenceColumn.userId] as? Int
        else {
            return nil
        }
        
        let genreString = dict[PreferenceColumn.preferredGenres] as? String ?? ""
        
        let genres = genreString.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines)}.filter { !$0.isEmpty }
        
        let authorString = dict[PreferenceColumn.preferredAuthor] as? String ?? ""
        
        let authors = authorString.split(separator: ",").map{
            String($0).trimmingCharacters(in: .whitespacesAndNewlines)}.filter{
                !$0.isEmpty
        }

        return PreferenceModel(
            id: id,
            userId: userId,
            preferredGenres: genres,
            preferredSize: dict[PreferenceColumn.preferredSize] as? String ?? "",
            preferredAuthor: authors
        )
    }
}
