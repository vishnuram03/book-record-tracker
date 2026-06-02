import Foundation

final class RecommendationCacheModel: DatabaseModel {
    static let tableName = "recommendation_cache"
    static let primaryKey = "id"

    var id: Int?
    var userId: Int
    var openLibraryId: String
    var title: String
    var author: String
    var genre: String
    var bookDescription: String
    var coverUrl: String
    var cachedAt: String

    init(
        id: Int? = nil,
        userId: Int,
        openLibraryId: String,
        title: String,
        author: String,
        genre: String = "",
        bookDescription: String = "",
        coverUrl: String = "",
        cachedAt: String
    ) {
        self.id = id
        self.userId = userId
        self.openLibraryId = openLibraryId
        self.title = title
        self.author = author
        self.genre = genre
        self.bookDescription = bookDescription
        self.coverUrl = coverUrl
        self.cachedAt = cachedAt
    }

    static func columnDefinitions() -> [(String, DatabaseColumnType)] {
        [
            ("id", .integer),
            ("user_id", .integer),
            ("open_library_id", .text),
            ("title", .text),
            ("author", .text),
            ("genre", .text),
            ("description", .text),
            ("cover_url", .text),
            ("cached_at", .text)
        ]
    }

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "user_id": userId,
            "open_library_id": openLibraryId,
            "title": title,
            "author": author,
            "genre": genre,
            "description": bookDescription,
            "cover_url": coverUrl,
            "cached_at": cachedAt
        ]

        if let id {
            dict["id"] = id
        }

        return dict
    }

    static func fromDictionary(_ dict: [String: Any]) -> RecommendationCacheModel? {
        guard
            let id = dict["id"] as? Int,
            let userId = dict["user_id"] as? Int,
            let openLibraryId = dict["open_library_id"] as? String,
            let title = dict["title"] as? String,
            let author = dict["author"] as? String,
            let cachedAt = dict["cached_at"] as? String
        else {
            return nil
        }

        return RecommendationCacheModel(
            id: id,
            userId: userId,
            openLibraryId: openLibraryId,
            title: title,
            author: author,
            genre: dict["genre"] as? String ?? "",
            bookDescription: dict["description"] as? String ?? "",
            coverUrl: dict["cover_url"] as? String ?? "",
            cachedAt: cachedAt
        )
    }
}
