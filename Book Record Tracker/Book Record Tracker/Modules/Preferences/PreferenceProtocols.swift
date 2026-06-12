//
//  PreferenceProtocols.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 03/06/26.
//

import UIKit


protocol PreferenceViewProtocol : AnyObject{
    var presenter: PreferencePresenterProtocol? { get set }
    
    func showError(message: String)
    func showSuccess(message: String)
}

protocol PreferencePresenterProtocol  : AnyObject{
    var view : PreferenceViewProtocol? { get set }
    var interactor: PreferenceInteractorInputProtocol? { get set }
    var router : PreferenceRouterProtocol? { get set }
    
    func viewDidLoad()
    func didTapSave(selectedGenres: [String], preferredSize: String?)
    
}

protocol PreferenceInteractorInputProtocol : AnyObject{
    var presenter: PreferenceInteractorOutputProtocol? { get set }
    
    func savePreference(selectedGenres: [String], preferredSize: String)
}

protocol PreferenceInteractorOutputProtocol : AnyObject{
    func didSavePreferenceSuccessfully()
    func didFailSavePreference(message: String)
}

protocol PreferenceRouterProtocol : AnyObject{
    static func createModule() -> UIViewController
    func navigateToHome(from view: PreferenceViewProtocol)
}
