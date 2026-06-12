//
//  UserBookRepository.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 11/06/26.
//

protocol UserBookRepositoryProtocol : AnyObject {
    func fetchUserBooks(for userId: Int) -> [UserBookModel]
    func fetchAllUserBooks() -> [UserBookModel]
}

class UserBookRepository : UserBookRepositoryProtocol{
    private let database : DatabaseManager
    
    init(database: DatabaseManager = .shared){
        self.database = database
    }
    
    func fetchUserBooks(for userId: Int) -> [UserBookModel] {
       return database.fetchWhere(UserBookModel.self, where: [UserBookModel.UserBookColumn.userId : userId])
    }
    func fetchAllUserBooks() -> [UserBookModel] {
        return database.fetchAll(UserBookModel.self)
    }
}
