//
//  BookDetailProtocols.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 12/06/26.
//

import UIKit

protocol BookDetailViewProtocol: AnyObject {
    var presenter: BookDetailPresenterProtocol? { get set }
    
    func showBookDetails(book: BookModel, userBook : UserBookModel?)
    func showError(message: String)
}
protocol BookDetailPresenterProtocol: AnyObject {
    var view : BookDetailViewProtocol? { get set }
    var interactor: BookDetailInteractorInputProtocol? { get set }
    var router: BookDetailRouterProtocol? { get set }
    
    func viewDidLoad()
    func didTapAddToLibrary()
    
}
protocol BookDetailInteractorInputProtocol: AnyObject {
    var presenter : BookDetailInteractorOutputProtocol? { get set }
    func getBookDetails()
    func addBookToLibrary()
}
protocol BookDetailInteractorOutputProtocol: AnyObject {
    func didLoadBookDetails(book: BookModel, userBook: UserBookModel?)
    func didAddBookToLibrary(book: BookModel,userBook: UserBookModel)
    func didFailToAddBook(message: String)

}
protocol BookDetailRouterProtocol: AnyObject {
    static func createModule(book: BookModel, userBook: UserBookModel?) -> UIViewController
}
