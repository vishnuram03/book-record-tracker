//
//  SignupProtocols.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 03/06/26.
//

import UIKit

protocol SignupViewProtocol: AnyObject {
    var presenter: SignupPresenterProtocol? { get set}
    
    func showError(message: String)
    func showSuccess(message: String)
}

protocol SignupPresenterProtocol: AnyObject {
    var view: SignupViewProtocol? { get set }
    var interactor: SignupInteractorInputProtocol? { get set }
    var router: SignupRouterProtocol? { get set }
    
    func viewDidLoad()
    func didTapSignUp(email: String?, username: String?, password: String?,confirmPassword: String?)
    func didPressReturnOnUsername(_ username: String?) -> Bool
    func didPressReturnOnEmail(_ email: String?) -> Bool
    func didPressReturnOnPassword(_ password: String?) -> Bool
    func didPressReturnOnConfirmPassword(password: String?, confirmPassword: String?) -> Bool
    
}

protocol SignupInteractorInputProtocol: AnyObject {
    var presenter: SignupInteractorOutputProtocol? { get set }
    
    func signup(username: String,email: String, password: String)
}

protocol SignupInteractorOutputProtocol: AnyObject {
    func didSignupSuccess(user: UserModel)
    func didSignupFailed(message: String)
    
}

protocol SignupRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func navigateToPreference(from view: SignupViewProtocol?)
}
