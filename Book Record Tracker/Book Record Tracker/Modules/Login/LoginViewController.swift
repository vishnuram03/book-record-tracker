//
//  LoginViewController.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 03/06/26.
//

import UIKit

class LoginView: UIViewController, LoginViewProtocol {
    var presenter: LoginPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureActions()

        passwordEyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        passwordTextField.rightView = makePasswordRightView(button: passwordEyeButton)
        passwordTextField.rightViewMode = .always
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dissmisskeyboard))
        view.addGestureRecognizer(tap)
        
        
        keyboardObservers()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func dissmisskeyboard() {
        view.endEditing(true)
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Login To\nYour Account"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .left
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.placeholder = "Enter Email Address"
        emailTextField.borderStyle = .roundedRect
        emailTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        emailTextField.textColor = .secondaryLabel
        emailTextField.keyboardType = .emailAddress
        emailTextField.layer.cornerRadius = 8
        emailTextField.layer.borderWidth = 1
        emailTextField.returnKeyType = .next
        emailTextField.autocapitalizationType = .none
        return emailTextField
    }()

    private let passwordTextField: UITextField = {
        let passwordField = UITextField()
        passwordField.placeholder = "Enter Password"
        passwordField.borderStyle = .roundedRect
        passwordField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        passwordField.textColor = .secondaryLabel
        passwordField.layer.borderWidth = 1
        passwordField.layer.cornerRadius = 8
        passwordField.returnKeyType = .done
        passwordField.isSecureTextEntry = true
        return passwordField
    }()

    private let passwordEyeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        return button
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.layer.cornerRadius = 12
        return button
    }()

    private let emailErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()

    private let passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()
    
    private func keyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)) , name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)) , name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let kewboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        scrollView.contentInset.bottom = kewboardFrame.height + 20
        scrollView.verticalScrollIndicatorInsets.bottom = kewboardFrame.height
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }

    func configureView() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false

        let formStackView = UIStackView(arrangedSubviews: [
            emailTextField,
            emailErrorLabel,
            passwordTextField,
            passwordErrorLabel,
            loginButton
        ])
        formStackView.axis = .vertical
        formStackView.spacing = 6
        formStackView.alignment = .fill
        formStackView.isLayoutMarginsRelativeArrangement = true
        [emailErrorLabel, passwordErrorLabel].forEach {
            formStackView.setCustomSpacing(14, after: $0)
        }

        let contentStackView = UIStackView(arrangedSubviews: [
            titleLabel,
            formStackView
        ])
        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.alignment = .fill
        // 1. create contentView
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false

        // 2. correct hierarchy
        scrollView.addSubview(contentView)
        contentView.addSubview(contentStackView)
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([

            // scrollView fills full screen including under keyboard
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            // contentView fills scrollView
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            // contentView at minimum fills screen height
            contentView.heightAnchor.constraint(
                greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor
            ),

            // contentStackView centered vertically — adapts to portrait and landscape
            contentStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -20),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),

            // minimum heights — flexible not rigid
            emailTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            passwordTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            loginButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }

    func configureActions() {
        emailTextField.delegate = self
        passwordTextField.delegate = self

        loginButton.addTarget(
            self,
            action: #selector(didTapLogin),
            for: .touchUpInside
        )

        emailTextField.addTarget(
            self,
            action: #selector(textDidChange),
            for: .editingChanged
        )

        passwordTextField.addTarget(
            self,
            action: #selector(textDidChange),
            for: .editingChanged
        )
    }

    @objc func didTapLogin() {
        presenter?.didTapLogin(
            email: emailTextField.text,
            password: passwordTextField.text
        )
    }

    @objc func textDidChange() {
        clearError()
    }

    @objc func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()

        let image = passwordTextField.isSecureTextEntry ? UIImage(systemName: "eye") : UIImage(systemName: "eye.slash")
        passwordEyeButton.setImage(image, for: .normal)
    }

    func showError(message: String) {
        clearError()

        let lowercasedMessage = message.lowercased()
        if lowercasedMessage.contains("email") {
            show(message: message, in: emailErrorLabel)
        } else {
            show(message: message, in: passwordErrorLabel)
        }
    }

    func showSuccess(message: String) {
        clearError()
    }

    private func clearError() {
        [emailErrorLabel, passwordErrorLabel].forEach { label in
            label.text = ""
            label.isHidden = true
        }
    }

    private func show(message: String, in label: UILabel) {
        label.text = message
        label.isHidden = false
    }

    private func makePasswordRightView(button: UIButton) -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 42, height: 44))
        button.frame = CGRect(x: 0, y: 0, width: 28, height: 44)
        containerView.addSubview(button)
        return containerView
    }
}

extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            if presenter?.didPressReturnOnEmail(emailTextField.text) == true {
                passwordTextField.becomeFirstResponder()
            }
        } else if textField == passwordTextField {
            if presenter?.didPressReturnOnPassword(
                email: emailTextField.text,
                password: passwordTextField.text
            ) == true {
                passwordTextField.resignFirstResponder()
                didTapLogin()
            }
        }

        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = textField.text ?? ""
        
        guard let stringRange = Range(range, in: currentString) else { return true }
        
        let updatedText = currentString.replacingCharacters(in: stringRange, with: string)
        
        switch textField {
        case emailTextField:
            return updatedText.count <= 40
        case passwordTextField:
            return updatedText.count <= 20
        default:
            return true
        }
    }
}
