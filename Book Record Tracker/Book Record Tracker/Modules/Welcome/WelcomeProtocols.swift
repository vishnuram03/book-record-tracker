import UIKit

protocol WelcomeViewProtocol: AnyObject {
    var presenter: WelcomePresenterProtocol? { get set }
}

protocol WelcomePresenterProtocol: AnyObject {
    var view: WelcomeViewProtocol? { get set }
    var interactor: WelcomeInteractorInputProtocol? { get set }
    var router: WelcomeRouterProtocol? { get set }

    func viewDidLoad()
    func didTapLogin()
    func didTapSignup()
}

protocol WelcomeInteractorInputProtocol: AnyObject {
    var presenter: WelcomeInteractorOutputProtocol? { get set }
}

protocol WelcomeInteractorOutputProtocol: AnyObject {}

protocol WelcomeRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func navigateToLogin(from view: WelcomeViewProtocol?)
    func navigateToSignup(from view: WelcomeViewProtocol?)
}
