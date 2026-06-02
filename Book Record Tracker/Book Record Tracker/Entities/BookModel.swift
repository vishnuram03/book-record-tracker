import Foundation

enum BookStatus: String, CaseIterable {
    case wantToRead = "Want to Read"
    case currentlyReading = "Currently Reading"
    case completed = "Completed"
}

enum Genre: String, CaseIterable {
    case fiction = "Fiction"
    case fantasy = "Fantasy"
    case biography = "Biography"
    case thriller = "Thriller"
    case selfHelp = "Self Help"
    case scienceFiction = "Science Fiction"
    case romance = "Romance"
    case mystery = "Mystery"
}

final class BookModel: DatabaseModel {

    static let tableName = "books"
    static let primaryKey = bookColumn.bookId

    var id: Int?
    var bookName: String
    var author: String
    var bookDescription: String
    var genre: [Genre]
    var totalPages: Int
    var coverImagePath: String?

    init(
        id: Int? = nil,
        bookName: String,
        author: String,
        bookDescription: String = "",
        genre: [Genre],
        totalPages: Int,
        coverImagePath: String? = nil
    ) {
        self.id = id
        self.bookName = bookName
        self.author = author
        self.bookDescription = bookDescription
        self.genre = genre
        self.totalPages = totalPages
        self.coverImagePath = coverImagePath
    }

    enum bookColumn {
        static let bookId = "book_id"
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
            bookColumn.genre: genre.map(\.rawValue).joined(separator: ","),
            bookColumn.totalPages: totalPages
        ]

        if let id {
            dict[bookColumn.bookId] = id
        }

        if let coverImagePath {
            dict[bookColumn.coverImagePath] = coverImagePath
        }

        return dict
    }

    static func fromDictionary(_ dict: [String : Any]) -> BookModel? {

        guard
            let id = dict[bookColumn.bookId] as? Int,
            let bookName = dict[bookColumn.bookName] as? String,
            let author = dict[bookColumn.author] as? String,
            let genreString = dict[bookColumn.genre] as? String,
            let totalPages = dict[bookColumn.totalPages] as? Int
        else {
            return nil
        }

        let genres = genreString
            .split(separator: ",")
            .compactMap {
                Genre(rawValue: String($0))
            }

        return BookModel(
            id: id,
            bookName: bookName,
            author: author,
            bookDescription: dict[bookColumn.description] as? String ?? "",
            genre: genres,
            totalPages: totalPages,
            coverImagePath: dict[bookColumn.coverImagePath] as? String
        )
    }
}
