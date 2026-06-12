//
//  SignupRouter.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 03/06/26.
//
import UIKit
class SignupRouter: SignupRouterProtocol {
    
    
    static func createModule() -> UIViewController {
        let view = SignupView()
        let presenter = SignupPresenter()
        let interactor = SignupInteractor()
        let router = SignupRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateToPreference(from view: SignupViewProtocol?) {
        guard let sourceView = view as? UIViewController else { return }
        
        let placeholder = PreferenceRouter.createModule()
        placeholder.title = "Signup"
        sourceView.navigationController?.setViewControllers([placeholder], animated: true)
    }
}
