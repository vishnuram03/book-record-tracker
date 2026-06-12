//
//  BooksRepository.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 11/06/26.
//

protocol BooksRepositoryProtocol : AnyObject{
    func fetchAllBooks() -> [BookModel]
    func fetchBook(by Id: Int) -> BookModel?
    func insertBook(_ books: BookModel) -> Bool
    func searchBooks(query : String) -> [BookModel]
    func fetchBooks(by genre: String) -> [BookModel]
    
}

final class BooksRepository: BooksRepositoryProtocol {
    
    private let dataBase : DatabaseManager
    
    init(dataBase: DatabaseManager = .shared){
        self.dataBase = dataBase
    }
    func fetchAllBooks() -> [BookModel] {
        let results =  dataBase.fetchAll(BookModel.self)
        print("📚 fetchAll returned: \(results.count)")
        return results
    }
    func fetchBook(by id: Int) -> BookModel? {
        return dataBase.fetchWhere(BookModel.self, where: [BookModel.bookColumn.bookId: id]).first
    }
    func insertBook(_ books: BookModel) -> Bool {
        return dataBase.insert(books)
    }
    func searchBooks(query: String) -> [BookModel] {
        return dataBase.search(
            BookModel.self,
            columns: ["book_name", "author"],
            query: query
        )
    }
    func fetchBooks(by genre: String) -> [BookModel] {
        return dataBase.fetchWhere(
            BookModel.self,
            where: ["genre": genre]
        )
    }
}
