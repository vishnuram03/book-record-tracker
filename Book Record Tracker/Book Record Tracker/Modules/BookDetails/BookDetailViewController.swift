//
//  BookDetailViewProtocol.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 12/06/26.
//
import UIKit

class BookDetailViewController : UIViewController, BookDetailViewProtocol {
    var presenter : BookDetailPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        presenter?.viewDidLoad()
        
            }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        
    }
    
    func showBookDetails(book: BookModel, userBook: UserBookModel?) {
        configureHeader(book: book , userBook : userBook)
        configureStats(book: book , userBook : userBook)
        configureDescription(book: book)
        configureUserSection(with : userBook)
        configureButton(userBook: userBook)
    }
    
    func showError(message: String){
        
    }
    
    func configureHeader(book: BookModel, userBook : UserBookModel?) {
        
    }
    
    func configureStats(book: BookModel, userBook : UserBookModel?) {
        
    }
    func configureDescription(book: BookModel) {
        
    }
    func configureUserSection(with userBook: UserBookModel?) {
        
    }
    func configureButton(userBook: UserBookModel?) {
        
    }
}
