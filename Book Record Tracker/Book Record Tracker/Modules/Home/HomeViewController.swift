//
//  HomeViewController.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 08/06/26.
//
import UIKit

class HomeViewController: UITabBarController {

    let homeContentViewController = HomeContentViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad( )
        setUpTabs()
        configureTabBarAppearance()
      
    }
    
   
    func setUpTabs() {
        let homeContent = UINavigationController(rootViewController: homeContentViewController)
        homeContent.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        
    let dashBoard = UINavigationController(rootViewController: UIViewController())
        dashBoard.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "chart.bar.fill"), tag: 1)
        
    let addBook = UINavigationController(rootViewController: UIViewController())
        addBook.tabBarItem = UITabBarItem(title: "Add ", image: UIImage(systemName: "plus.circle.fill"), tag: 2)
        
    let session = UINavigationController(rootViewController: UIViewController())
        session.tabBarItem = UITabBarItem(title: "Session", image: UIImage(systemName: "book.fill"), tag: 3)
        
    let tasks = UINavigationController(rootViewController: UIViewController())
        tasks.tabBarItem = UITabBarItem(title: "Tasks", image: UIImage(systemName: "list.bullet.clipboard.fill"), tag: 4)
        
        
        viewControllers = [homeContent, dashBoard, addBook, session, tasks]
    }
    
    private func configureTabBarAppearance() {

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()

        // Background
        appearance.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.04)

//         Subtle top separator
        appearance.shadowColor = UIColor.separator.withAlphaComponent(1.0)

        // Premium blue accent
        let accentColor = UIColor(
            red: 32/255,
            green: 102/255,
            blue: 240/255,
            alpha: 1.0
        )

        // Selected State
        appearance.stackedLayoutAppearance.selected.iconColor = accentColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: accentColor,
            .font: UIFont.systemFont(ofSize: 11, weight: .semibold)
        ]

        // Normal State
        appearance.stackedLayoutAppearance.normal.iconColor = .secondaryLabel
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.secondaryLabel,
            .font: UIFont.systemFont(ofSize: 11, weight: .regular)
        ]

        tabBar.standardAppearance = appearance

        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }

        tabBar.tintColor = accentColor
        tabBar.unselectedItemTintColor = .secondaryLabel
    }
    
}

// Home Content view Controller

class HomeContentViewController : UIViewController,  HomeViewProtocol {
    
    var presenter: HomePresenterProtocol?
    
    
    private var recommendedBooks : [BookModel] = []
    private var myPicks: [(userBook: UserBookModel, book: BookModel)] = []
    
    private var recommendedBooksCollectionView : UICollectionView!
    private var myPicksCollectionView : UICollectionView!
    private var myPicksHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("🟢 HomeContentViewController viewDidLoad — instance: \(self)")
        view.backgroundColor = UIColor(
            red: 247/255,
            green: 251/255,
            blue: 255/255,
            alpha: 1
        )
        
        func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            configureNavigationBar()
            navigationController?.isNavigationBarHidden = false
        }
        
        if #available(iOS 26.0, *) {
            navigationController?.navigationBar.preferredBehavioralStyle = .pad
        }
        configureNavigationBar()
        configureCollectionViews()
        configureLayout()
        myPicksCollectionView.isHidden = true
        myPicksEmptyView.isHidden = false
        presenter?.viewDidLoad()
        print("🔗 presenter after viewDidLoad: \(String(describing: presenter))")
    }

  
    func configureNavigationBar() {
        
      //  navigationItem.largeTitleDisplayMode = .never

        // MARK: - Colors

        let primaryBlue = UIColor(
            red: 37/255,
            green: 99/255,
            blue: 235/255,
            alpha: 1
        )

        let softBlue = UIColor(
            red: 239/255,
            green: 246/255,
            blue: 255/255,
            alpha: 1
        )

        let navBackground = UIColor(
            red: 122/255,
            green: 184/255,
            blue: 251/255,
            alpha: 1
        )
        // MARK: - Logo

        let logoContainer = UIView()
        logoContainer.backgroundColor = softBlue
        logoContainer.layer.cornerRadius = 18
        logoContainer.layer.cornerCurve = .continuous
        logoContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoContainer.widthAnchor.constraint(equalToConstant: 36),
            logoContainer.heightAnchor.constraint(equalToConstant: 36)
        ])

        let logoImageView = UIImageView(
            image: UIImage(systemName: "book.closed.fill")
        )

        logoImageView.tintColor = primaryBlue
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        logoContainer.addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: logoContainer.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: logoContainer.centerYAnchor)
        ])

        // MARK: - Greeting

        let greetingLabel = UILabel()
        greetingLabel.text = "Welcome to 👋"
        greetingLabel.font = .systemFont(ofSize: 11, weight: .medium)
        greetingLabel.textColor = .secondaryLabel

        let titleLabel = UILabel()
        titleLabel.text = "Book Tracker"
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = UIColor(
            red: 30/255,
            green: 64/255,
            blue: 175/255,
            alpha: 1
        )

        let titleStack = UIStackView(
            arrangedSubviews: [
                greetingLabel,
                titleLabel
            ]
        )

        titleStack.axis = .vertical
        titleStack.spacing = 1
        titleStack.alignment = .leading

        // MARK: - Left Stack

        let leftStack = UIStackView(
            arrangedSubviews: [
                logoContainer,
                titleStack
            ]
        )

        leftStack.axis = .horizontal
        leftStack.spacing = 10
        leftStack.alignment = .center

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            customView: leftStack
        )

        // MARK: - Dark Mode Button

        let darkModeButton = UIButton(type: .system)

        darkModeButton.setImage(
            UIImage(systemName: "moon.fill"),
            for: .normal
        )

        darkModeButton.tintColor = primaryBlue
        darkModeButton.backgroundColor = softBlue
        darkModeButton.layer.cornerRadius = 18
        darkModeButton.layer.cornerCurve = .continuous
        darkModeButton.frame = CGRect(
            x: 0,
            y: 0,
            width: 36,
            height: 36
        )

        darkModeButton.addTarget(
            self,
            action: #selector(didTapDarkMode),
            for: .touchUpInside
        )

        // MARK: - Profile Button

        let profileButton = UIButton(type: .system)

        profileButton.setImage(
            UIImage(systemName: "person.fill"),
            for: .normal
        )

        profileButton.tintColor = primaryBlue
        profileButton.backgroundColor = softBlue
        profileButton.layer.cornerRadius = 18
        profileButton.layer.cornerCurve = .continuous
        profileButton.frame = CGRect(
            x: 0,
            y: 0,
            width: 36,
            height: 36
        )

        profileButton.addTarget(
            self,
            action: #selector(didTapProfile),
            for: .touchUpInside
        )

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: profileButton),
            UIBarButtonItem(customView: darkModeButton)
        ]

            // MARK: - Navigation Bar Appearance

//        navigationController?.navigationBar.prefersLargeTitles = false
//        navigationController?.navigationBar.tintColor = primaryBlue
        let appearance = UINavigationBarAppearance()

        appearance.configureWithOpaqueBackground()

        appearance.backgroundColor = navBackground

        appearance.shadowColor = UIColor.black.withAlphaComponent(0.08)

        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label
        ]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance

        navigationController?.navigationBar.tintColor = primaryBlue
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = UIColor(red: 167/255, green: 139/255, blue: 250/255, alpha: 1)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    
    
    
    func configureCollectionViews(){
        // recommendation - Horizontal View
        let recommendationLayout = UICollectionViewFlowLayout()
        recommendationLayout.scrollDirection = .horizontal
        recommendationLayout.itemSize = CGSize(width: 96, height: 150)
        recommendationLayout.minimumLineSpacing = 12
        recommendationLayout.minimumInteritemSpacing = 12
        recommendationLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        recommendedBooksCollectionView = UICollectionView(frame: .zero, collectionViewLayout: recommendationLayout)
        recommendedBooksCollectionView.backgroundColor = UIColor(
            red: 244/255,
            green: 249/255,
            blue: 255/255,
            alpha: 1
        )
        recommendedBooksCollectionView.showsHorizontalScrollIndicator = false
        recommendedBooksCollectionView.register(RecommendationCell.self, forCellWithReuseIdentifier: RecommendationCell.identifier)
        recommendedBooksCollectionView.delegate = self
        recommendedBooksCollectionView.dataSource = self
        
        
        // MyPicks - vertical 2 cloumn grid layout
        let myPicksLayout = UICollectionViewFlowLayout()
        myPicksLayout.scrollDirection = .vertical
        let width = (UIScreen.main.bounds.width - 44) / 2
        myPicksLayout.itemSize = CGSize(width: width, height: 150)
        myPicksLayout.minimumLineSpacing = 12
        myPicksLayout.minimumInteritemSpacing = 12
        myPicksLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        myPicksCollectionView = UICollectionView(frame: .zero, collectionViewLayout: myPicksLayout)
        myPicksCollectionView.backgroundColor = .clear
        myPicksCollectionView.showsVerticalScrollIndicator = false
        myPicksCollectionView.register(MyPicksCell.self, forCellWithReuseIdentifier: MyPicksCell.identifier)
        myPicksCollectionView.delegate = self
        myPicksCollectionView.dataSource = self
        
        
    }
    
    func configureLayout(){
        
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // all books banner
        let allBooksBanner = makeAllBooksBanner()
        
        let recoHeader = makeSectionHeader(title: "Based on your Taste", buttonTitle: "See all", action: #selector(didTapSeeAllRecommended))
        let picksHeader = makeSectionHeader(title: "My Picks", buttonTitle: "See all", action: #selector(didTapSeeAllMyPicks))
        
        
        
        recommendedBooksCollectionView.translatesAutoresizingMaskIntoConstraints = false
        myPicksCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(allBooksBanner)
        contentView.addSubview(recoHeader)
        contentView.addSubview(recommendedBooksCollectionView)
        contentView.addSubview(picksHeader)
        contentView.addSubview(myPicksCollectionView)
        contentView.addSubview(myPicksEmptyView)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            allBooksBanner.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            allBooksBanner.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            allBooksBanner.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            allBooksBanner.heightAnchor.constraint(equalToConstant: 64),
            
            recoHeader.topAnchor.constraint(equalTo: allBooksBanner.bottomAnchor, constant: 20),
            recoHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recoHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            recoHeader.heightAnchor.constraint(equalToConstant: 24),
            
            recommendedBooksCollectionView.topAnchor.constraint(equalTo: recoHeader.bottomAnchor, constant: 8),
            recommendedBooksCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recommendedBooksCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recommendedBooksCollectionView.heightAnchor.constraint(equalToConstant: 170),
            
            picksHeader.topAnchor.constraint(equalTo: recommendedBooksCollectionView.bottomAnchor, constant: 20),
            picksHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            picksHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            picksHeader.heightAnchor.constraint(equalToConstant: 24),
            
            myPicksCollectionView.topAnchor.constraint(equalTo: picksHeader.bottomAnchor, constant: 10),
            myPicksCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            myPicksCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            myPicksCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            myPicksEmptyView.topAnchor.constraint(equalTo: picksHeader.bottomAnchor, constant: 10),
            myPicksEmptyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            myPicksEmptyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            myPicksEmptyView.heightAnchor.constraint(equalToConstant: 160),
            myPicksEmptyView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)


            ])
        
        myPicksHeightConstraint = myPicksCollectionView.heightAnchor.constraint(equalToConstant: 320)
        myPicksHeightConstraint?.isActive = true
        
    }
    
    private func makeAllBooksBanner() -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(red: 248/255,green: 252/255,blue: 255/255,alpha: 1)
        container.layer.cornerRadius = 12
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.45).cgColor
        container.translatesAutoresizingMaskIntoConstraints = false
        container.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAllBooks))
        container.addGestureRecognizer(tap)
        
        let iconView = UIView()
        iconView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.12)
        iconView.layer.cornerRadius = 8
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let icon = UIImageView(image: UIImage(systemName: "book.fill"))
        icon.tintColor = .systemBlue
        icon.translatesAutoresizingMaskIntoConstraints = false
        iconView.addSubview(icon)
        
        let titleLabel = UILabel()
        titleLabel.text = "All Books"
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .label
        
        let subTitleLabel = UILabel()
        subTitleLabel.text = "Browse full catalogue"
        subTitleLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        subTitleLabel.textColor = .secondaryLabel
        
        let textstack = UIStackView(arrangedSubviews: [titleLabel,subTitleLabel])
        textstack.axis = .vertical
        textstack.spacing = 2
        
        let arrowImage = UIImageView(image: UIImage(systemName: "chevron.right.circle.fill"))
        arrowImage.tintColor = .systemBlue
        arrowImage.contentMode = .scaleAspectFit
        
        let mainStack = UIStackView(arrangedSubviews: [iconView,textstack,arrowImage])
        mainStack.axis = .horizontal
        mainStack.spacing = 10
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 20),
            icon.heightAnchor.constraint(equalToConstant: 20),
            
            iconView.widthAnchor.constraint(equalToConstant: 36),
            iconView.heightAnchor.constraint(equalToConstant: 36),
            arrowImage.widthAnchor.constraint(equalToConstant: 22),
            arrowImage.heightAnchor.constraint(equalToConstant: 22),
            
            
            mainStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 14),
            mainStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -14),
            mainStack.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ])
        
        return container

    }
    
    private func makeSectionHeader(title: String , buttonTitle: String, action: Selector) -> UIView {
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = UIColor(red: 26/255, green: 26/255, blue: 46/255, alpha: 1)
        
        let seeAllButton = UIButton(type: .system)
        seeAllButton.setTitle(buttonTitle, for: .normal)
        seeAllButton.setTitleColor(UIColor(red: 127/255, green: 119/255, blue: 221/255, alpha: 1), for: .normal)
        seeAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        seeAllButton.backgroundColor = UIColor(red: 238/255, green: 237/255, blue: 254/255, alpha: 1)
        seeAllButton.layer.cornerRadius = 10
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            
            config.contentInsets = NSDirectionalEdgeInsets(
                top : 5,
                leading: 10,
                bottom: 5,
                trailing: 10
            )
        }
        else{
            seeAllButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        }
        seeAllButton.addTarget(self, action: action, for: .touchUpInside)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(titleLabel)
        container.addSubview(seeAllButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            seeAllButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            seeAllButton.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ])
        return container
    }
//    private func loadSampleData() {
//        let samples = [
//            BookModel(id: 1, bookName: "Atomic Habits", author: "James Clear", genre: [.selfHelp], totalPages: 320),
//            BookModel(id: 2, bookName: "The Psychology of Money", author: "Morgan Housel", genre: [.finance], totalPages: 256),
//            BookModel(id: 3, bookName: "Deep Work", author: "Cal Newport", genre: [.technology], totalPages: 296),
//            BookModel(id: 4, bookName: "The Hobbit", author: "J.R.R. Tolkien", genre: [.fantasy], totalPages: 310),
//            BookModel(id: 5, bookName: "Sapiens", author: "Yuval Noah Harari", genre: [.history], totalPages: 464)
//        ]
//        
//        updateRecommendations(samples)
//        updateMyPicks([
//            (UserBookModel(id: 1, userId: 1, bookId: 1, status: BookStatus.currentlyReading.rawValue, pagesRead: 120, addedDate: "2026-06-10"), samples[0]),
//            (UserBookModel(id: 2, userId: 1, bookId: 2, status: BookStatus.yetToRead.rawValue, pagesRead: 0, addedDate: "2026-06-10"), samples[1]),
//            (UserBookModel(id: 3, userId: 1, bookId: 3, status: BookStatus.completed.rawValue, pagesRead: 296, addedDate: "2026-06-10"), samples[2]),
//            (UserBookModel(id: 4, userId: 1, bookId: 4, status: BookStatus.addedToRead.rawValue, pagesRead: 0, addedDate: "2026-06-10"), samples[3])
//        ])
//    }
    
    private func updateRecommendations(_ books: [BookModel]){
        print("🖥 View received recommendations: \(books.count)")
        self.recommendedBooks = books
        recommendedBooksCollectionView.reloadData()
    }
    
    private func updateMyPicks(_ pairs: [(userBook: UserBookModel, book: BookModel)]) {
        
        self.myPicks = pairs
        // update my picks Cllection view height dynamically
        
        if pairs.isEmpty{
            myPicksCollectionView.isHidden = true
            myPicksEmptyView.isHidden = false
        }
        else{
            myPicksEmptyView.isHidden = true
            myPicksCollectionView.isHidden = false
        }
        
        let rows = ceil(Double(pairs.count) / 2.0)
        let itemHeight = (UIScreen.main.bounds.width - 48) / 2 + 50
        let totalHeight = rows * (itemHeight + 12)
        myPicksCollectionView.constraints
            .first(where: { $0.firstAttribute == .height })?
            .constant = totalHeight

        myPicksCollectionView.reloadData()

        
//        let rows = max(1, ceil(Double(myPicks.count)/2.0))
//        let itemHeight = 150.0
//        let totalHeight = rows * itemHeight + max(0, rows - 1) * 12
//        
//        myPicksHeightConstraint?.constant = totalHeight
//        
//        myPicksCollectionView.reloadData()
    }
    
    
    @objc func didTapAllBooks() {
        presenter?.didTapAllBooks()
    }
    @objc func didTapSeeAllRecommended(){
        presenter?.didTapSeeAllRecommended()
    }
    @objc func didTapSeeAllMyPicks(){
        presenter?.didTapSeeAllMyPicks()
    }
    
    @objc func didTapDarkMode(){
        presenter?.didTapDarkModeToggle()
    }
    
    @objc func didTapProfile(){
        presenter?.didTapProfile()
    }
    
    func showRecommendation(_ books: [BookModel]) {
        updateRecommendations(books)
    }
    
    func showMyPicks(_ pair : [(userBook : UserBookModel, book : BookModel)]) {
        updateMyPicks(pair)
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default))
           present(alert, animated: true)
    }
    func showLoading(_ isLoading: Bool) {
        if isLoading {
                loadingIndicator.startAnimating()
            } else {
                loadingIndicator.stopAnimating()
            }
    }
    
    
    private let myPicksEmptyView : UIView = {
        let container = UIView()
        container.backgroundColor = .systemYellow.withAlphaComponent(0.2)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let icon = UIImageView(image: UIImage(systemName: "books.vertical"))
        icon.tintColor = UIColor.systemGray3
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "No books yet"
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = UIColor(red: 26/255, green: 26/255, blue: 46/255, alpha: 1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let subtitleLabel = UILabel()
            subtitleLabel.text = "Books you add to your library will appear here"
            subtitleLabel.font = UIFont.systemFont(ofSize: 12)
            subtitleLabel.textColor = .systemGray
            subtitleLabel.textAlignment = .center
            subtitleLabel.numberOfLines = 0
            subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(icon)
        container.addSubview(titleLabel)
        container.addSubview(subtitleLabel)

            NSLayoutConstraint.activate([
                icon.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
                icon.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                icon.widthAnchor.constraint(equalToConstant: 40),
                icon.heightAnchor.constraint(equalToConstant: 40),

                titleLabel.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 12),
                titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),

                subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
                subtitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 32),
                subtitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -32),
            ])

            return container
    }()
}

extension HomeContentViewController : UICollectionViewDelegateFlowLayout , UICollectionViewDataSource , UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == recommendedBooksCollectionView {
            return recommendedBooks.count
        }
        else{
            return myPicks.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == recommendedBooksCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendationCell.identifier, for: indexPath) as! RecommendationCell
            cell.configure(with: recommendedBooks[indexPath.row])
            return cell
        }
        else{
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: MyPicksCell.identifier, for: indexPath) as! MyPicksCell
            let pair = myPicks[indexPath.row]
            cell.configure(with: pair.userBook, from: pair.book)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == recommendedBooksCollectionView {
            let book = recommendedBooks[indexPath.row]
            presenter?.didSelectRecommendedBook(book: book)
        }
        else{
            let pair = myPicks[indexPath.row]
            presenter?.didSelectMyPick(pairs : pair)
        }
    }
}
