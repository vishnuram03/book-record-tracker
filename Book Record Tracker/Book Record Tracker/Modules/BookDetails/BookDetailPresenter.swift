//
//  BookDetailPresenter.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 12/06/26.
//

class BookDetailPresenter: BookDetailPresenterProtocol  {
    weak var view: BookDetailViewProtocol?
    weak var router: BookDetailRouterProtocol?
    weak var interactor: BookDetailInteractorInputProtocol?
    
    func viewDidLoad() {
        interactor?.getBookDetails()
    }
    
    func didTapAddToLibrary() {
        interactor?.addBookToLibrary()
    }
}
extension BookDetailPresenter : BookDetailInteractorOutputProtocol{
    
    func didLoadBookDetails(book: BookModel, userBook: UserBookModel?) {
        view?.showBookDetails(book: book, userBook: userBook)
    }
    
    func didFailToAddBook(message: String) {
        view?.showError(message: message)
    }
    func didAddBookToLibrary(book: BookModel,userBook: UserBookModel) {
         view?.showBookDetails(book: book, userBook: userBook)
    }
}
