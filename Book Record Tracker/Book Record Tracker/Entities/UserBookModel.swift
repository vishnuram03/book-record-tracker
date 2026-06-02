import Foundation

final class UserBookModel: DatabaseModel {
    static let tableName = "user_books"
    static let primaryKey = "book_id"

    var id: Int?
    var userId: Int
    var bookId: Int
    var status: String
    var isbn: String?
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
        status: String = BookStatus.wantToRead.rawValue,
        isbn: String? = nil,
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
        self.isbn = isbn
        self.pagesRead = pagesRead
        self.isFavourite = isFavourite
        self.notes = notes
        self.addedDate = addedDate
        self.startedDate = startedDate
        self.completedDate = completedDate
        self.rating = rating
    }

    static func columnDefinitions() -> [(String, DatabaseColumnType)] {
        [
            ("id", .integer),
            ("user_id", .integer),
            ("book_id", .integer),
            ("status", .text),
            ("isbn", .text),
            ("pages_read", .integer),
            ("is_favourite", .integer),
            ("notes", .text),
            ("added_date", .text),
            ("started_date", .text),
            ("completed_date", .text),
            ("rating", .real)
        ]
    }

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "user_id": userId,
            "book_id": bookId,
            "status": status,
            "pages_read": pagesRead,
            "is_favourite": isFavourite ? 1 : 0,
            "notes": notes,
            "added_date": addedDate,
            "rating": rating
        ]

        if let id {
            dict["id"] = id
        }

        if let isbn {
            dict["isbn"] = isbn
        }

        if let startedDate {
            dict["started_date"] = startedDate
        }

        if let completedDate {
            dict["completed_date"] = completedDate
        }

        return dict
    }

    static func fromDictionary(_ dict: [String: Any]) -> UserBookModel? {
        guard
            let id = dict["id"] as? Int,
            let userId = dict["user_id"] as? Int,
            let bookId = dict["book_id"] as? Int,
            let status = dict["status"] as? String,
            let addedDate = dict["added_date"] as? String
        else {
            return nil
        }

        return UserBookModel(
            id: id,
            userId: userId,
            bookId: bookId,
            status: status,
            isbn: dict["isbn"] as? String,
            pagesRead: dict["pages_read"] as? Int ?? 0,
            isFavourite: (dict["is_favourite"] as? Int ?? 0) == 1,
            notes: dict["notes"] as? String ?? "",
            addedDate: addedDate,
            startedDate: dict["started_date"] as? String,
            completedDate: dict["completed_date"] as? String,
            rating: dict["rating"] as? Double ?? 0
        )
    }
}
