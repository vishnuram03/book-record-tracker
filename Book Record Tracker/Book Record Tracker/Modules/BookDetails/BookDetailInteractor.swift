//
//  BookDetailInteractor.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 12/06/26.
//

class BookDetailInteractor: BookDetailInteractorInputProtocol {
    
    weak var presenter : BookDetailInteractorOutputProtocol?
    
    //data passed from router
    var book: BookModel
    var userBook: UserBookModel?
    
    init(book: BookModel , userBook: UserBookModel?){
        self.book = book
        self.userBook = userBook
    }
    
    func getBookDetails(){
        // send Book and userBook to presenter
        presenter?.didLoadBookDetails(book: book, userBook: userBook)
    }
    func addBookToLibrary(){
        // create userBook model save it in libraary
        presenter?.didAddBookToLibrary(book: book, userBook: userBook!)
    }
}
