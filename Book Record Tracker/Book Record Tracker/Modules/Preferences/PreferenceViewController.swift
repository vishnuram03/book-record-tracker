//
//  PreferenceViewController.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 03/06/26.
//

import UIKit

class PreferenceView: UIViewController, PreferenceViewProtocol {
    var presenter: PreferencePresenterProtocol?

    private let genres = Genre.allCases.map { $0.rawValue }
    private let pageSizes = ["0-100", "100-200", "200-400", "400+"]
    private var selectedGenres: Set<String> = []
    private var selectedPageSize: String?
    private var genreButtons: [UIButton] = []
    private var pageSizeButtons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureActions()
        presenter?.viewDidLoad()
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "What genres are\nyou interested in?"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .left
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()

    private let genreContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        
        view.layer.cornerRadius = 18
        return view
    }()

    private let genreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        return stackView
    }()

    private let sizeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Preferred length of books"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        return label
    }()

    private let pageSizeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select page length", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 10
        
        if #available(iOS 15.0, *){
            var config = UIButton.Configuration.plain()

            config.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 14,
                bottom: 0,
                trailing: 44
            )

            button.configuration = config
        }else{
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 44)
        }
        
        return button
    }()

    private let dropdownImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let pageSizeDropdownStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.backgroundColor = .secondarySystemBackground
        stackView.layer.cornerRadius = 10
        stackView.clipsToBounds = true
        stackView.isHidden = true
        return stackView
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()

    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let scrollView : UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    func configureView() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false

        configureGenreButtons()
        configurePageSizeButtons()

        genreContainerView.addSubview(genreStackView)
        genreStackView.translatesAutoresizingMaskIntoConstraints = false

        pageSizeButton.addSubview(dropdownImageView)
        dropdownImageView.translatesAutoresizingMaskIntoConstraints = false

        let contentStackView = UIStackView(arrangedSubviews: [
            titleLabel,
            genreContainerView,
            sizeTitleLabel,
            pageSizeButton,
            pageSizeDropdownStackView,
            errorLabel,
            continueButton
        ])
        contentStackView.axis = .vertical
        contentStackView.spacing = 18
        contentStackView.alignment = .fill
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentStackView)

        view.addSubview(scrollView)

        NSLayoutConstraint.activate([

            // scrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // contentStackView directly in scrollView — no centerY, just top to bottom
            contentStackView.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor,
                constant: 32
            ),
            contentStackView.leadingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.leadingAnchor,
                constant: 28
            ),
            contentStackView.trailingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.trailingAnchor,
                constant: -28
            ),
            contentStackView.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor,
                constant: -32
            ),

            // this is critical — tells scrollView how wide the content is
            contentStackView.widthAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.widthAnchor,
                constant: -56
            ),

            // genreStackView inside genreContainerView
            // use genreContainerView directly — NOT safeAreaLayoutGuide
            genreStackView.topAnchor.constraint(
                equalTo: genreContainerView.topAnchor, constant: 18
            ),
            genreStackView.leadingAnchor.constraint(
                equalTo: genreContainerView.leadingAnchor, constant: 16
            ),
            genreStackView.trailingAnchor.constraint(
                equalTo: genreContainerView.trailingAnchor, constant: -16
            ),
            genreStackView.bottomAnchor.constraint(
                equalTo: genreContainerView.bottomAnchor, constant: -18
            ),

            // pageSizeButton and dropdown
            pageSizeButton.heightAnchor.constraint(equalToConstant: 48),
            dropdownImageView.trailingAnchor.constraint(
                equalTo: pageSizeButton.trailingAnchor, constant: -14
            ),
            dropdownImageView.centerYAnchor.constraint(
                equalTo: pageSizeButton.centerYAnchor
            ),
            dropdownImageView.widthAnchor.constraint(equalToConstant: 18),
            dropdownImageView.heightAnchor.constraint(equalToConstant: 18),

            continueButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    func configureActions() {
        pageSizeButton.addTarget(self, action: #selector(togglePageSizeDropdown), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
    }

    private func configureGenreButtons() {
        let rows = [
            Array(genres.prefix(3)),
            Array(genres.dropFirst(3).prefix(2)),
            Array(genres.dropFirst(5).prefix(3)),
            Array(genres.dropFirst(8).prefix(2)),
            Array(genres.dropFirst(10))
        ]
        
        rows.forEach { rowGenres in
        let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 10
            rowStackView.distribution = .fillProportionally
            
            rowGenres.forEach { genre in
            let button = makeGenreButton(title: genre)
                genreButtons.append(button)
                rowStackView.addArrangedSubview(button)
            }
            genreStackView.addArrangedSubview(rowStackView)
        }
    }

    private func configurePageSizeButtons() {
        pageSizes.forEach { size in
            let button = UIButton(type: .system)
            button.setTitle(size, for: .normal)
            button.setTitleColor(.label, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            button.contentHorizontalAlignment = .left
            
            if #available(iOS 15.0, *){
                var config = UIButton.Configuration.plain()

                config.contentInsets = NSDirectionalEdgeInsets(
                    top: 0,
                    leading: 14,
                    bottom: 0,
                    trailing: 44
                )

                button.configuration = config
            }else{
                button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 44)
            }
            
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
            button.addTarget(self, action: #selector(didSelectPageSize(_:)), for: .touchUpInside)
            pageSizeButtons.append(button)
            pageSizeDropdownStackView.addArrangedSubview(button)
        }
    }

    private func makeGenreButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 17
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.25).cgColor
        button.heightAnchor.constraint(equalToConstant: 34).isActive = true
        button.addTarget(self, action: #selector(didTapGenre(_:)), for: .touchUpInside)
        return button
    }

    @objc private func didTapGenre(_ sender: UIButton) {
        guard let genre = sender.currentTitle else { return }

        if selectedGenres.contains(genre) {
            selectedGenres.remove(genre)
        } else {
            selectedGenres.insert(genre)
        }

        updateGenreButton(sender, isSelected: selectedGenres.contains(genre))
        clearError()
    }

    @objc private func togglePageSizeDropdown() {
        pageSizeDropdownStackView.isHidden.toggle()
        let imageName = pageSizeDropdownStackView.isHidden ? "chevron.down" : "chevron.up"
        dropdownImageView.image = UIImage(systemName: imageName)
    }

    @objc private func didSelectPageSize(_ sender: UIButton) {
        selectedPageSize = sender.currentTitle
        pageSizeButton.setTitle(sender.currentTitle, for: .normal)
        pageSizeDropdownStackView.isHidden = true
        dropdownImageView.image = UIImage(systemName: "chevron.down")
        clearError()
    }

    @objc private func didTapContinue() {
        presenter?.didTapSave(
            selectedGenres: Array(selectedGenres).sorted(),
            preferredSize: selectedPageSize
        )
    }

    private func updateGenreButton(_ button: UIButton, isSelected: Bool) {
        button.backgroundColor = isSelected ? .systemBlue : .systemBackground
        button.setTitleColor(isSelected ? .white : .label, for: .normal)
        button.layer.borderColor = isSelected ? UIColor.systemBlue.cgColor : UIColor.systemBlue.withAlphaComponent(0.25).cgColor
    }

    func showError(message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }

    func showSuccess(message: String) {
        clearError()
    }

    private func clearError() {
        errorLabel.text = ""
        errorLabel.isHidden = true
    }
}
