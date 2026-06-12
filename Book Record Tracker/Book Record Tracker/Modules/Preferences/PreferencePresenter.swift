//
//  PreferencePresenter.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 03/06/26.
//

class PreferencePresenter: PreferencePresenterProtocol, PreferenceInteractorOutputProtocol {
    
    weak var view: PreferenceViewProtocol?
    var interactor: PreferenceInteractorInputProtocol?
    var router: PreferenceRouterProtocol?
    
    func viewDidLoad() { }
    
    func didTapSave(selectedGenres: [String], preferredSize: String?) {
        guard selectedGenres.isEmpty == false else {
            view?.showError(message: "Please select a genre")
            return
        }

        guard let preferredSize, preferredSize.isEmpty == false else {
            view?.showError(message: "Please select a page length")
            return
        }

        interactor?.savePreference(selectedGenres: selectedGenres, preferredSize: preferredSize)
    }

    func didSavePreferenceSuccessfully() {
        guard let view else { return }
        router?.navigateToHome(from: view)
    }

    func didFailSavePreference(message: String) {
        view?.showError(message: message)
    }
}
