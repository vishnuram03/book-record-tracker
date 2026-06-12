//
//  LoginProtocols.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 03/06/26.
//

import UIKit

protocol LoginViewProtocol: AnyObject {
    var presenter: LoginPresenterProtocol? { get set }

    func showError(message: String)
    func showSuccess(message: String)
}

protocol LoginPresenterProtocol: AnyObject {
    var view: LoginViewProtocol? { get set }
    var interactor: LoginInteractorInputProtocol? { get set }
    var router: LoginRouterProtocol? { get set }

    func viewDidLoad()
    func didTapLogin(email: String?, password: String?)
    func didPressReturnOnEmail(_ email: String?) -> Bool
    func didPressReturnOnPassword(email: String?, password: String?) -> Bool
}

protocol LoginInteractorInputProtocol: AnyObject {
    var presenter: LoginInteractorOutputProtocol? { get set }

    func login(email: String, password: String)
}

protocol LoginInteractorOutputProtocol: AnyObject {
    func didLoginSuccess(user: UserModel)
    func didLoginFailed(message: String)
}

protocol LoginRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func navigateToHome(from view: LoginViewProtocol)
}
