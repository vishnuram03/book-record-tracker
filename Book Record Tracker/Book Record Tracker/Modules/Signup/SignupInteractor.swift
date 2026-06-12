//
//  signupInteractor.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 03/06/26.
//

import Foundation
import UIKit

class SignupInteractor : SignupInteractorInputProtocol{
    weak var presenter : SignupInteractorOutputProtocol?
    
    private let  userRepository : UserRepositoryProtocol
    private let sessionManager: SessionManagingProtocol
    
    init(
        userRepository: UserRepositoryProtocol = UserRepository.shared,
        sessionManager: SessionManagingProtocol = SessionManager.shared
    ){
        self.userRepository = userRepository
        self.sessionManager = sessionManager
    }
    
    func signup(username: String,email: String, password: String) {
        
        do {
                   let user = try userRepository.signup(
                       username: username,
                       email: email,
                       password: password
                   )

                   if let userId = user.id {
                       sessionManager.saveSession(userId: userId)
                   }

                   presenter?.didSignupSuccess(user: user)

               } catch let error as UserRepositoryError {
                   // UserRepositoryError enum errorDescription comes here
                   presenter?.didSignupFailed(message: error.localizedDescription)

               } catch {
                   presenter?.didSignupFailed(message: error.localizedDescription)
               }
    }
    
}
