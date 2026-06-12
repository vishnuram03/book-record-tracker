import UIKit

class HomeRouter: HomeRouterProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        
        let tabBarVC = HomeViewController()
        let presenter = HomePresenter()
        let interactor = HomeInteractor()
        let router = HomeRouter()
        
        // wire VIPER
        tabBarVC.homeContentViewController.presenter = presenter
        presenter.view = tabBarVC.homeContentViewController
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = tabBarVC
        
        return tabBarVC
    }
    
    func navigateToBookDetails(book: BookModel, userBook: UserBookModel?, from view: HomeViewProtocol) {
        // later
        guard let sourceView = view as? UIViewController else { return }
        
        let placeHolder = BookDetailRouter.createModule(book: book, userBook: userBook)
        placeHolder.title = "Book details"
        
        sourceView.navigationController?.pushViewController(placeHolder, animated: true)
    }
    
    func navigateToProfile(from view: HomeViewProtocol) {
        guard let sourceView = view as? UIViewController else { return }

        let profileVC = UIViewController() //ProfileViewController()

        sourceView.navigationController?.pushViewController(profileVC,animated: true)
    }
    
    func navigateToSeeAll(type: SeeAllType, from view: HomeViewProtocol)
    {
        guard let sourceView = view as? UIViewController else { return }

        let booksGridVC = UIViewController()//BooksGridViewController(type: type)

        sourceView.navigationController?.pushViewController(booksGridVC,animated: true)
    }
}
