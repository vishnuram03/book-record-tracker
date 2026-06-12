//
//  HomeInteractor.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 08/06/26.
//

import Foundation

class HomeInteractor : HomeInteractorInputProtocol {
    weak var presenter : HomeInteractorOutputProtocol?
    
    private let bookRepository: BooksRepositoryProtocol
    private let userBookRepository: UserBookRepositoryProtocol
    private let preferenceRepository: PreferenceRepositoryProtocol
    
    init(bookRepository: BooksRepositoryProtocol = BooksRepository(), userBookRepository: UserBookRepositoryProtocol = UserBookRepository(), preferenceRepository: PreferenceRepositoryProtocol = PreferenceRepository()) {
        self.bookRepository = bookRepository
        self.userBookRepository = userBookRepository
        self.preferenceRepository = preferenceRepository
    }
    
    func loadBooksIfNeeded() {
        print("load books if needed is being appear called")
        let existing = bookRepository.fetchAllBooks()
        guard existing.isEmpty else {
            print("Books already loaded - skipping JSON import")
            return
        }
        
        print("load books is calledcontains books")
        
        guard let url =  Bundle.main.url(forResource: "Books", withExtension: "json"),
              let data = try? Data(contentsOf : url)
        else{
            presenter?.didFailWithError(message: "books.json not found")
                   return
        }
        
        let decoder = JSONDecoder()
        
        guard let jsonBooks = try? decoder.decode([BookJSON].self, from: data) else {
            presenter?.didFailWithError(message: "Failed to parse books.json")
            return
        }
        
        for jsonBook in jsonBooks {
            
            guard let book = jsonBook.toBookModel() else { continue }
            _ = bookRepository.insertBook(book)
        }
        print(" Books seeded successfully — \(jsonBooks.count) books loaded")
    }
    
    func fetchRecommendedBooks(for userId: Int) {
        let allBooks = bookRepository.fetchAllBooks()
        print("📚 All books count: \(allBooks.count)")

        
        guard let preference = preferenceRepository.fetchPreference(userId: userId) else {
           
            presenter?.didLoadRecommendedBooks(allBooks)
            return
        }
        
        let preferredGenre = preference.preferredGenres
        
        guard !preferredGenre.isEmpty else {
                   presenter?.didLoadRecommendedBooks(allBooks)
                   return
        }
        print("📚 All books count: \(allBooks.count)")

        
        let recommended = allBooks.filter { book in
            book.genre.contains(where : { preferredGenre.contains($0.rawValue)})
        }
        
        presenter?.didLoadRecommendedBooks(recommended)
        
    }
    func fetchMyPicks(for userId: Int) {
        
        let allUserBooks = userBookRepository.fetchAllUserBooks()
        print("🔍 Total user_books in DB: \(allUserBooks.count)")
        print("🔍 Looking for userId: \(userId)")
        
        
        print("my pick up fetch method is called")
        let userBooks = userBookRepository.fetchUserBooks(for: userId)

        guard !userBooks.isEmpty else {
            print("userBook count \(userBooks.count)  for user: \(userId)")
            presenter?.didLoadMyPicks([])
            return
        }

        var pairs: [(userBook: UserBookModel, book: BookModel)] = []

        for userBook in userBooks {
            if let book = bookRepository.fetchBook(by: userBook.bookId) {
                print("printing the book details \(book)")
                pairs.append((userBook: userBook, book: book))
            }
        }

        presenter?.didLoadMyPicks(pairs)
    }
}
