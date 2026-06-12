import Foundation

final class ReadingSessionModel: DatabaseModel {
    static let tableName = "reading_sessions"
    static let primaryKey = ReadingSessionColumn.readingId

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
    
    enum ReadingSessionColumn {
        static let readingId = "reading_id"
        static let bookId = "book_id"
        static let userId = "user_id"
        static let pagesRead = "pages_read"
        static let sessionDate = "session_date"
        static let durationMinutes = "duration_minutes"
    }

    static func columnDefinitions() -> [(String, DatabaseColumnType)] {
        [
            (ReadingSessionColumn.readingId, .integer),
            (ReadingSessionColumn.bookId, .integer),
            (ReadingSessionColumn.userId, .integer),
            (ReadingSessionColumn.pagesRead, .integer),
            (ReadingSessionColumn.sessionDate, .text),
            (ReadingSessionColumn.durationMinutes, .integer)
        ]
    }

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            ReadingSessionColumn.bookId: bookId,
            ReadingSessionColumn.userId: userId,
            ReadingSessionColumn.pagesRead: pagesRead,
            ReadingSessionColumn.sessionDate: sessionDate,
            ReadingSessionColumn.durationMinutes: durationMinutes
        ]

        if let id {
            dict[ReadingSessionColumn.readingId] = id
        }

        return dict
    }

    static func fromDictionary(_ dict: [String: Any]) -> ReadingSessionModel? {
        guard
            let id = dict[ReadingSessionColumn.readingId] as? Int,
            let bookId = dict[ReadingSessionColumn.bookId] as? Int,
            let userId = dict[ReadingSessionColumn.userId] as? Int,
            let pagesRead = dict[ReadingSessionColumn.pagesRead] as? Int,
            let sessionDate = dict[ReadingSessionColumn.sessionDate] as? String
        else {
            return nil
        }

        return ReadingSessionModel(
            id: id,
            bookId: bookId,
            userId: userId,
            pagesRead: pagesRead,
            sessionDate: sessionDate,
            durationMinutes: dict[ReadingSessionColumn.durationMinutes] as? Int ?? 0
        )
    }
}
