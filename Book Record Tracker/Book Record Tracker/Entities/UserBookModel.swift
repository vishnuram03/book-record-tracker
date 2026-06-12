import Foundation

enum BookStatus: String, CaseIterable {
    case addedToRead = "added to Read"
    case yetToRead = "Yet to Read"
    case currentlyReading = "Currently Reading"
    case completed = "Completed"
}

final class UserBookModel: DatabaseModel {
    static let tableName = "user_books"
    static let primaryKey = UserBookColumn.userBookId

    var id: Int?
    var userId: Int
    var bookId: Int
    var status: String
    var pagesRead: Int
    var isFavourite: Bool
    var notes: String
    var addedDate: String
    var startedDate: String?
    var completedDate: String?
    var rating: Double

    init(
        id: Int? = nil,
        userId: Int,
        bookId: Int,
        status: String = BookStatus.yetToRead.rawValue,
        pagesRead: Int = 0,
        isFavourite: Bool = false,
        notes: String = "",
        addedDate: String,
        startedDate: String? = nil,
        completedDate: String? = nil,
        rating: Double = 0
    ) {
        self.id = id
        self.userId = userId
        self.bookId = bookId
        self.status = status
        self.pagesRead = pagesRead
        self.isFavourite = isFavourite
        self.notes = notes
        self.addedDate = addedDate
        self.startedDate = startedDate
        self.completedDate = completedDate
        self.rating = rating
    }

    enum UserBookColumn {
        static let userBookId = "user_book_id"
        static let userId = "user_id"
        static let bookId = "book_id"
        static let status = "status"
        static let pagesRead = "pages_read"
        static let isFavourite = "is_favourite"
        static let notes = "notes"
        static let addedDate = "added_date"
        static let startedDate = "started_date"
        static let completedDate = "completed_date"
        static let rating = "rating"
    }

    static func columnDefinitions() -> [(String, DatabaseColumnType)] {
        [
            (UserBookColumn.userBookId, .integer),
            (UserBookColumn.userId, .integer),
            (UserBookColumn.bookId, .integer),
            (UserBookColumn.status, .text),
            (UserBookColumn.pagesRead, .integer),
            (UserBookColumn.isFavourite, .integer),
            (UserBookColumn.notes, .text),
            (UserBookColumn.addedDate, .text),
            (UserBookColumn.startedDate, .text),
            (UserBookColumn.completedDate, .text),
            (UserBookColumn.rating, .real)
        ]
    }

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            UserBookColumn.userId: userId,
            UserBookColumn.bookId: bookId,
            UserBookColumn.status: status,
            UserBookColumn.pagesRead: pagesRead,
            UserBookColumn.isFavourite: isFavourite ? 1 : 0,
            UserBookColumn.notes: notes,
            UserBookColumn.addedDate: addedDate,
            UserBookColumn.rating: rating
        ]

        if let id {
            dict[UserBookColumn.userBookId] = id
        }

        if let startedDate {
            dict[UserBookColumn.startedDate] = startedDate
        }

        if let completedDate {
            dict[UserBookColumn.completedDate] = completedDate
        }

        return dict
    }

    static func fromDictionary(_ dict: [String: Any]) -> UserBookModel? {
        guard
            let id = dict[UserBookColumn.userBookId] as? Int
                  ?? (dict[UserBookColumn.userBookId] as? Int64).map(Int.init),
            let userId = dict[UserBookColumn.userId] as? Int
                  ?? (dict[UserBookColumn.userId] as? Int64).map(Int.init),
            let bookId = dict[UserBookColumn.bookId] as? Int
                  ?? (dict[UserBookColumn.bookId] as? Int64).map(Int.init),
            let status = dict[UserBookColumn.status] as? String,
            let addedDate = dict[UserBookColumn.addedDate] as? String
        else {
            return nil
        }

        return UserBookModel(
            id: id,
            userId: userId,
            bookId: bookId,
            status: status,
            pagesRead: dict[UserBookColumn.pagesRead] as? Int
                ?? (dict[UserBookColumn.pagesRead] as? Int64).map(Int.init) ?? 0,
            isFavourite: ((dict[UserBookColumn.isFavourite] as? Int
                ?? (dict[UserBookColumn.isFavourite] as? Int64).map(Int.init)) ?? 0) == 1,
            notes: dict[UserBookColumn.notes] as? String ?? "",
            addedDate: addedDate,
            startedDate: dict[UserBookColumn.startedDate] as? String,
            completedDate: dict[UserBookColumn.completedDate] as? String,
            rating: dict[UserBookColumn.rating] as? Double ?? 0
        )
    }
}
