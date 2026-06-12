//
//  BookDetailRouter.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 12/06/26.
//

import UIKit

class BookDetailRouter: BookDetailRouterProtocol {
    static func createModule(book: BookModel, userBook: UserBookModel?) -> UIViewController {
        let view  = BookDetailViewController()
        let interactor = BookDetailInteractor(book: book, userBook: userBook)
        let presenter = BookDetailPresenter()
        let router = BookDetailRouter()
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.view = view
        presenter.router = router
        interactor.presenter = presenter
        
        
       return view
    }
}
