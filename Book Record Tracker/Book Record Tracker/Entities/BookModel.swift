import Foundation


enum Genre: String, CaseIterable {
    case fiction = "Fiction"
    case fantasy = "Fantasy"
    case biography = "Biography"
    case thriller = "Thriller"
    case selfHelp = "Self Help"
    case comedy = " Comedy"
    case romance = "Romance"
    case mystery = "Mystery"
    case psychology = "Psychology"
    case finance = "Finance"
    case technology = "Technology"
    case history = "History"
}

final class BookModel: DatabaseModel {

    static let tableName = "books"
    static let primaryKey = bookColumn.bookId

    var id: Int?
    var isbn: String?
    var bookName: String
    var author: String
    var bookDescription: String
    var genre: [Genre]
    var totalPages: Int
    var coverImagePath: String?

    init(
        id: Int? = nil,
        isbn: String? = nil,
        bookName: String,
        author: String,
        bookDescription: String = "",
        genre: [Genre],
        totalPages: Int,
        coverImagePath: String? = nil
    ) {
        self.id = id
        self.isbn = isbn
        self.bookName = bookName
        self.author = author
        self.bookDescription = bookDescription
        self.genre = genre
        self.totalPages = totalPages
        self.coverImagePath = coverImagePath
    }

    enum bookColumn {
        static let bookId = "book_id"
        static let isbn = "isbn"
        static let bookName = "book_name"
        static let author = "author"
        static let description = "description"
        static let genre = "genre"
        static let totalPages = "total_pages"
        static let coverImagePath = "cover_image_path"
    }

    static func columnDefinitions() -> [(String, DatabaseColumnType)] {
        [
            (bookColumn.bookId, .integer), 
            (bookColumn.isbn, .text),
            (bookColumn.bookName, .text),
            (bookColumn.author, .text),
            (bookColumn.description, .text),
            (bookColumn.genre, .text),
            (bookColumn.totalPages, .integer),
            (bookColumn.coverImagePath, .text)
        ]
    }

    func toDictionary() -> [String : Any] {

        var dict: [String : Any] = [
            bookColumn.bookName: bookName,
            bookColumn.author: author,
            bookColumn.description: bookDescription,
            bookColumn.genre: genre.map(\.rawValue).joined(separator: ", "),
            bookColumn.totalPages: totalPages
        ]

        if let id {
            dict[bookColumn.bookId] = id
        }

        if let isbn {
            dict[bookColumn.isbn] = isbn
        }

        if let coverImagePath {
            dict[bookColumn.coverImagePath] = coverImagePath
        }

        return dict
    }

    static func fromDictionary(_ dict: [String : Any]) -> BookModel? {

        guard
            let id = dict[bookColumn.bookId] as? Int
                    ?? (dict[bookColumn.bookId] as? Int64).map(Int.init),
            let bookName = dict[bookColumn.bookName] as? String,
            let author = dict[bookColumn.author] as? String,
            let totalPages =
                (dict[bookColumn.totalPages] as? Int)
                ?? (dict[bookColumn.totalPages] as? Int64).map(Int.init),
            let genreString = dict[bookColumn.genre] as? String
        else {
            return nil
        }

        let genres = genreString
            .split(separator: ",")
            .compactMap {
                Genre(rawValue: String($0).trimmingCharacters(in: .whitespacesAndNewlines))
            }

        return BookModel(
            id: id,
            isbn: dict[bookColumn.isbn] as? String,
            bookName: bookName,
            author: author,
            bookDescription: dict[bookColumn.description] as? String ?? "",
            genre: genres,
            totalPages: totalPages,
            coverImagePath: dict[bookColumn.coverImagePath] as? String
        )
    }
}
