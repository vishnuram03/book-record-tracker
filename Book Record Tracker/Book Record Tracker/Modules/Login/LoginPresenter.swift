//
//  LoginPresenter.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 03/06/26.
//

import Foundation

final class LoginPresenter: LoginPresenterProtocol, LoginInteractorOutputProtocol {
    weak var view: LoginViewProtocol?
    var interactor: LoginInteractorInputProtocol?
    var router: LoginRouterProtocol?

    func viewDidLoad() { }

    func didTapLogin(email: String?, password: String?) {
        let email = email ?? ""
        let password = password ?? ""

        guard validateEmail(email) else { return }
        guard validatePassword(password) else { return }

        interactor?.login(
            email: email,
            password: password
        )
    }

    func didLoginSuccess(user: UserModel) {
        guard let view else { return }
        router?.navigateToHome(from: view)
    }

    func didLoginFailed(message: String) {
        view?.showError(message: message)
    }

    func didPressReturnOnEmail(_ email: String?) -> Bool {
        validateEmail(email ?? "")
    }

    func didPressReturnOnPassword(email: String?, password: String?) -> Bool {
        validatePassword(password ?? "")
    }

    private func validateEmail(_ email: String) -> Bool {
        do {
            try AuthValidator.validateEmail(email)
            view?.showSuccess(message: "")
            return true
        } catch {
            view?.showError(message: error.localizedDescription)
            return false
        }
    }

    private func validatePassword(_ password: String) -> Bool {
        guard password.isEmpty == false else {
            view?.showError(message: AuthValidationError.emptyPassword.localizedDescription)
            return false
        }

        view?.showSuccess(message: "")
        return true
    }
}
