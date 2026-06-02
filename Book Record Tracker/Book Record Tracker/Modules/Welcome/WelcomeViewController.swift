import UIKit

final class WelcomeViewController: UIViewController, WelcomeViewProtocol {
    var presenter: WelcomePresenterProtocol?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Book Record Tracker"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Track your library, reading progress, goals, and stats in one offline space."
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Account", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 8
        return button
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = .secondarySystemBackground
        button.tintColor = .label
        button.layer.cornerRadius = 8
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureActions()
        presenter?.viewDidLoad()
    }

    private func configureView() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false

        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            signupButton,
            loginButton
        ])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            signupButton.heightAnchor.constraint(equalToConstant: 52),
            loginButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    private func configureActions() {
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }

    @objc private func signupTapped() {
        presenter?.didTapSignup()
    }

    @objc private func loginTapped() {
        presenter?.didTapLogin()
    }
}
