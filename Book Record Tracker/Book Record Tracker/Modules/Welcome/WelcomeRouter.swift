import UIKit

final class WelcomeRouter: WelcomeRouterProtocol {
    static func createModule() -> UIViewController {
        let view = WelcomeViewController()
        let presenter = WelcomePresenter()
        let interactor = WelcomeInteractor()
        let router = WelcomeRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }

    func navigateToLogin(from view: WelcomeViewProtocol?) {
        guard let sourceView = view as? UIViewController else { return }
        let placeholder = ViewController()
        placeholder.title = "Login"
        sourceView.navigationController?.pushViewController(placeholder, animated: true)
    }

    func navigateToSignup(from view: WelcomeViewProtocol?) {
        guard let sourceView = view as? UIViewController else { return }
        let placeholder = ViewController()
        placeholder.title = "Signup"
        sourceView.navigationController?.pushViewController(placeholder, animated: true)
    }
}
