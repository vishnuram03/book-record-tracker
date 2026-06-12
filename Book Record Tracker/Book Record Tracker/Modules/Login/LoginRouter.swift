//
//  LoginRouter.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 03/06/26.
//

import UIKit

class LoginRouter: LoginRouterProtocol {
    static func createModule() -> UIViewController {
        let view = LoginView()
        let presenter = LoginPresenter()
        let interactor = LoginInteractor()
        let router = LoginRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }

    func navigateToHome(from view: LoginViewProtocol) {
        guard let sourceView = view as? UIViewController else { return }

        let placeholder = UIViewController()
        placeholder.view.backgroundColor = .systemBackground
        placeholder.title = "Home"

        sourceView.navigationController?.setViewControllers([placeholder], animated: true)
    }
}
