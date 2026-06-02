final class WelcomePresenter: WelcomePresenterProtocol {
    weak var view: WelcomeViewProtocol?
    var interactor: WelcomeInteractorInputProtocol?
    var router: WelcomeRouterProtocol?

    func viewDidLoad() {}

    func didTapLogin() {
        router?.navigateToLogin(from: view)
    }

    func didTapSignup() {
        router?.navigateToSignup(from: view)
    }
}

extension WelcomePresenter: WelcomeInteractorOutputProtocol {}
