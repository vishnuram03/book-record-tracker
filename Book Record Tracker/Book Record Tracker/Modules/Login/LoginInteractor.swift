//
//  LoginInteractor.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 03/06/26.
//

import Foundation

class LoginInteractor: LoginInteractorInputProtocol {
    weak var presenter: LoginInteractorOutputProtocol?

    private let userRepository: UserRepositoryProtocol
    private let sessionManager: SessionManagingProtocol

    init(
        userRepository: UserRepositoryProtocol = UserRepository.shared,
        sessionManager: SessionManagingProtocol = SessionManager.shared
    ) {
        self.userRepository = userRepository
        self.sessionManager = sessionManager
    }

    func login(email: String, password: String) {
        do {
            let user = try userRepository.login(
                email: email,
                password: password
            )

            if let userId = user.id {
                sessionManager.saveSession(userId: userId)
            }

            presenter?.didLoginSuccess(user: user)
        } catch let error as UserRepositoryError {
            presenter?.didLoginFailed(message: error.localizedDescription)
        } catch {
            presenter?.didLoginFailed(message: error.localizedDescription)
        }
    }
}
