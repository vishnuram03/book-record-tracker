//
//  PrefernceRouter.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 03/06/26.
//

import UIKit

class PreferenceRouter: PreferenceRouterProtocol {
    
    static func createModule() ->  UIViewController{
        let view = PreferenceView()
        let presenter = PreferencePresenter()
        let interactor = PreferenceInteractor()
        let router = PreferenceRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }
    
    func navigateToHome(from view: PreferenceViewProtocol) {
        guard let sourceView = view as? UIViewController else { return }
        
        let placeHolder = HomeRouter.createModule()
        placeHolder.title = "Home"
        sourceView.navigationController?.setViewControllers([placeHolder], animated: true)
    }
}
