//
//  PreferenceInteractor.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 03/06/26.
//

import Foundation
class PreferenceInteractor: PreferenceInteractorInputProtocol {
    weak var presenter : PreferenceInteractorOutputProtocol?
    
    private let preferenceRepository : PreferenceRepositoryProtocol
    private let sessionManager : SessionManagingProtocol
    
    init(
        preferenceRepository: PreferenceRepositoryProtocol = PreferenceRepository.shared,
        sessionManager: SessionManagingProtocol = SessionManager.shared
    ) {
        self.preferenceRepository = preferenceRepository
        self.sessionManager = sessionManager
    }
    
   func savePreference(selectedGenres: [String], preferredSize: String) {
       
       guard let userId = sessionManager.currentUserId else {
           presenter?.didFailSavePreference(message: "User session not found")
           return
       }
       
       do {
           try preferenceRepository.savePreference(
               userId: userId,
               preferredGenres: selectedGenres,
               preferredSize: preferredSize,
               preferredAuthor: []
           )
           presenter?.didSavePreferenceSuccessfully()
       }
       catch let error as PreferenceRepositoryError {
           presenter?.didFailSavePreference(message: error.localizedDescription)
       } catch {
           presenter?.didFailSavePreference(message: error.localizedDescription)
       }

    }
}
