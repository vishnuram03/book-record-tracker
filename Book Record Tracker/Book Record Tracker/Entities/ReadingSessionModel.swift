import Foundation

final class ReadingSessionModel: DatabaseModel {
    static let tableName = "reading_sessions"
    static let primaryKey = "id"

    var id: Int?
    var bookId: Int
    var userId: Int
    var pagesRead: Int
    var sessionDate: String
    var durationMinutes: Int

    init(
        id: Int? = nil,
        bookId: Int,
        userId: Int,
        pagesRead: Int,
        sessionDate: String,
        durationMinutes: Int = 0
    ) {
        self.id = id
        self.bookId = bookId
        self.userId = userId
        self.pagesRead = pagesRead
        self.sessionDate = sessionDate
        self.durationMinutes = durationMinutes
    }

    static func columnDefinitions() -> [(String, DatabaseColumnType)] {
        [
            ("id", .integer),
            ("book_id", .integer),
            ("user_id", .integer),
            ("pages_read", .integer),
            ("session_date", .text),
            ("duration_minutes", .integer)
        ]
    }

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "book_id": bookId,
            "user_id": userId,
            "pages_read": pagesRead,
            "session_date": sessionDate,
            "duration_minutes": durationMinutes
        ]

        if let id {
            dict["id"] = id
        }

        return dict
    }

    static func fromDictionary(_ dict: [String: Any]) -> ReadingSessionModel? {
        guard
            let id = dict["id"] as? Int,
            let bookId = dict["book_id"] as? Int,
            let userId = dict["user_id"] as? Int,
            let pagesRead = dict["pages_read"] as? Int,
            let sessionDate = dict["session_date"] as? String
        else {
            return nil
        }

        return ReadingSessionModel(
            id: id,
            bookId: bookId,
            userId: userId,
            pagesRead: pagesRead,
            sessionDate: sessionDate,
            durationMinutes: dict["duration_minutes"] as? Int ?? 0
        )
    }
}
