//
//  SignupPresenter.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 03/06/26.
//

import Foundation

final class SignupPresenter: SignupPresenterProtocol, SignupInteractorOutputProtocol {
    

    weak var view: SignupViewProtocol?
    var interactor: SignupInteractorInputProtocol?
    var router: SignupRouterProtocol?

    func viewDidLoad() { }

    func didTapSignUp(email: String?, username: String?, password: String?, confirmPassword: String?) {

        let email    = email    ?? ""
        let username = username ?? ""
        let password = password ?? ""
        let confirm  = confirmPassword ?? ""

        guard validateUsername(username) else { return }
        guard validateEmail(email) else { return }
        guard validatePassword(password) else { return }
        guard validateConfirmPassword(password: password, confirmPassword: confirm) else { return }

        //  validation passed, hand off to Interactor
        interactor?.signup(
            username: username,
            email: email,
            password: password
        )
    }

    // MARK: - SignupInteractorOutputProtocol
    func didSignupSuccess(user: UserModel) {
        router?.navigateToPreference(from: view)
    }

    func didSignupFailed(message: String) {
        // UserRepositoryError or any other error message comes here
        view?.showError(message: message)
    }

    func didPressReturnOnUsername(_ username: String?) -> Bool {
        validateUsername(username ?? "")
    }

    func didPressReturnOnEmail(_ email: String?) -> Bool {
        validateEmail(email ?? "")
    }

    func didPressReturnOnPassword(_ password: String?) -> Bool {
        validatePassword(password ?? "")
    }

    func didPressReturnOnConfirmPassword(password: String?, confirmPassword: String?) -> Bool {
        validateConfirmPassword(password: password ?? "", confirmPassword: confirmPassword ?? "")
    }

    private func validateUsername(_ username: String) -> Bool {
        do {
            try AuthValidator.validateUsername(username)
            view?.showSuccess(message: "")
            return true
        } catch {
            view?.showError(message: error.localizedDescription)
            return false
        }
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
        do {
            try AuthValidator.validatePasswordStrength(password)
            view?.showSuccess(message: "")
            return true
        } catch {
            view?.showError(message: error.localizedDescription)
            return false
        }
    }

    private func validateConfirmPassword(password: String, confirmPassword: String) -> Bool {
        guard password == confirmPassword else {
            view?.showError(message: "Passwords do not match.")
            return false
        }

        view?.showSuccess(message: "")
        return true
    }

}
