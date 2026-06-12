//
//  HomePresenter.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 08/06/26.
//

import UIKit

class HomePresenter: HomePresenterProtocol {
    weak var view: HomeViewProtocol?
    var router: HomeRouterProtocol?
    var interactor: HomeInteractorInputProtocol?
    
    func viewDidLoad(){
        print("🏠 HomePresenter viewDidLoad called")
        guard let userId = SessionManager.shared.currentUserId else { return }
        print("✅ userId: \(userId)")

        view?.showLoading(true)
        interactor?.loadBooksIfNeeded()
        interactor?.fetchRecommendedBooks(for: userId)
        interactor?.fetchMyPicks(for: userId)
    }
    func didSelectRecommendedBook(book: BookModel){
        router?.navigateToBookDetails(book: book, userBook: nil, from: view!)
    }
    func didSelectMyPick(pairs: (userBook: UserBookModel, book: BookModel)){
        let (userBook,book) = pairs
        router?.navigateToBookDetails(book: book ,userBook : userBook, from: view!)
    }
    func didTapAllBooks(){
        router?.navigateToSeeAll(type: .allBooks, from: view!)
    }
    func didTapProfile(){
        router?.navigateToProfile(from: view!)
    }
    func didTapSeeAllRecommended() {
        router?.navigateToSeeAll(type: .recommended, from: view!)
    }  // See all on recommendations section
    func didTapSeeAllMyPicks()  {
        router?.navigateToSeeAll(type: .myPicks, from: view!)
    }     // See all on my picks section
    func didTapDarkModeToggle(){
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else { return }
        
        if window.overrideUserInterfaceStyle == .dark {
            window.overrideUserInterfaceStyle = .light
        }else{
            window.overrideUserInterfaceStyle = .dark
        }
    }
}
extension HomePresenter: HomeInteractorOutputProtocol {
    func didLoadRecommendedBooks(_ books : [BookModel]){
        print("✅ Presenter received recommendations: \(books.count)")
        view?.showRecommendation(books)
    }
    func didLoadMyPicks(_ pair : [(userBook : UserBookModel, book : BookModel)]){
        view?.showLoading(false)
        print("✅ Presenter received picks: \(pair.count)")
        view?.showMyPicks(pair)
    }
    func didFailWithError(message: String){
        view?.showError(message: message)
    }
}
