//
//  HomeProtocols.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 08/06/26.
//

import UIKit


enum SeeAllType {
    case allBooks
    case recommended
    case myPicks
}

protocol HomeViewProtocol: AnyObject {
    var presenter : HomePresenterProtocol? { get set }
    func showRecommendation(_ books: [BookModel])
    func showMyPicks(_ pair: [(userBook: UserBookModel, book: BookModel)])
    func showError(message: String)
    func showLoading(_ isLoading: Bool)
}
protocol HomePresenterProtocol: AnyObject {
    var view : HomeViewProtocol? { get set }
    var interactor : HomeInteractorInputProtocol? { get set }
    var router : HomeRouterProtocol? { get set }
    func viewDidLoad()
    func didSelectRecommendedBook(book: BookModel)
    func didSelectMyPick(pairs: (userBook: UserBookModel, book: BookModel))
    func didTapAllBooks()
    func didTapProfile()
    func didTapSeeAllRecommended()   // See all on recommendations section
    func didTapSeeAllMyPicks()       // See all on my picks section
    func didTapDarkModeToggle()      // dark mode toggle in nav bar
}

protocol HomeInteractorInputProtocol: AnyObject {
    var presenter : HomeInteractorOutputProtocol? { get set }
    func loadBooksIfNeeded()
    func fetchRecommendedBooks(for userId : Int)
    func fetchMyPicks(for userId : Int)
    
}

protocol HomeInteractorOutputProtocol: AnyObject {
    func didLoadRecommendedBooks(_ books : [BookModel])
    func didLoadMyPicks(_ pair : [(userBook : UserBookModel, book : BookModel)])
    func didFailWithError(message: String)
}

protocol HomeRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func navigateToBookDetails(book: BookModel, userBook: UserBookModel?, from view: HomeViewProtocol)

    func navigateToProfile(from view: HomeViewProtocol)
    func navigateToSeeAll(type: SeeAllType, from view: HomeViewProtocol)
}
