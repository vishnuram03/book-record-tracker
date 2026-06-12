//
//  SignupViewController.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 03/06/26.
//
import UIKit

class SignupView : UIViewController , SignupViewProtocol
{
    var presenter: SignupPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureActions()
        passwordEyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        confirmEyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        passwordTextField.rightView = makePasswordRightView(button: passwordEyeButton)
        passwordTextField.rightViewMode = .always
        confirmPasswordField.rightView = makePasswordRightView(button: confirmEyeButton)
        confirmPasswordField.rightViewMode = .always
        
        let tap  = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        keyBoardObservers()

    }
    
    deinit {
           NotificationCenter.default.removeObserver(self)
       }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        confirmPasswordField.isSecureTextEntry.toggle()
        
        let image = passwordTextField.isSecureTextEntry ? UIImage(systemName: "eye") : UIImage(systemName: "eye.slash")
        let image2 = confirmPasswordField.isSecureTextEntry ? UIImage(systemName: "eye") : UIImage(systemName: "eye.slash")
        
        passwordEyeButton.setImage(image, for: .normal)
        confirmEyeButton.setImage(image2, for: .normal)
    }
    
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Sign up\nYour Account"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .left
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setAttriputedPlaceHolder(_ text: String, for field: UITextField){
        let placeHolder = NSMutableAttributedString(
            string: text + " ",
            attributes: [.foregroundColor: UIColor.secondaryLabel]
        )
        let astrix = NSAttributedString(string: "*", attributes: [.foregroundColor: UIColor.systemRed])
        
        placeHolder.append(astrix)
        field.attributedPlaceholder = placeHolder
    }
    
    private let usernameTextField : UITextField = {
        let field = UITextField()
        
        field.borderStyle = .roundedRect
        field.layer.cornerRadius = 8
        field.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        field.textColor = .label
        field.layer.borderWidth = 1
        field.returnKeyType = .next
        field.autocapitalizationType = .words
        return field
    }()
    
    private let emailTextField : UITextField = {
        let emailTextField = UITextField()

        emailTextField.borderStyle = .roundedRect
        emailTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        emailTextField.textColor = .label
        emailTextField.keyboardType = .emailAddress
        emailTextField.layer.cornerRadius = 8
        emailTextField.layer.borderWidth = 1
        emailTextField.returnKeyType = .next
        emailTextField.autocapitalizationType = .none
        
        return emailTextField
    }()
    
    private let passwordTextField : UITextField = {
        let passwordField = UITextField()
     
        passwordField.borderStyle = .roundedRect
        passwordField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        passwordField.textColor = .label
        passwordField.layer.borderWidth = 1
        passwordField.layer.cornerRadius = 8
        passwordField.returnKeyType = .next
        passwordField.isSecureTextEntry = true
        return passwordField
    }()
    
    private let confirmPasswordField: UITextField = {
        let confirmField = UITextField()
       
        confirmField.borderStyle = .roundedRect
        confirmField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        confirmField.textColor = .label
        confirmField.layer.borderWidth = 1
        confirmField.layer.cornerRadius = 8
        confirmField.returnKeyType = .done
        confirmField.isSecureTextEntry = true
        return confirmField
    }()
    
    private let passwordEyeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        return button
    }()
    
    private let confirmEyeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        return button
    }()
    
    private let signupButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let usernameErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.isHidden = true
        return label
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
    
    private let confirmPasswordErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    private let passwordRuleCases : [AuthValidationError] = [
        .passwordTooShort,
        .passwordMissingNumber,
        .passwordMissingLowercase,
        .passwordMissingUppercase
    ]
    private var ruleLabels : [UILabel] = []
    
    private let passwordRuleContainer : UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.isHidden = true
        return stackView
    }()
    

    
    private func configurePasswordRules(){
        ruleLabels = []
        
        passwordRuleCases.forEach{ rule in
        let label = UILabel()
            label.text = "x " + (rule.errorDescription ?? "" )
            label.textColor = .systemRed
            label.font = UIFont.systemFont(ofSize: 13, weight: . regular)
            
            ruleLabels.append(label)
            passwordRuleContainer.addArrangedSubview(label)
        }
    }
    
    private func updatePasswordRules(for password: String){
        
        let failingError = AuthValidator.passwordErrors(for: password)
        
        for (index, rule) in passwordRuleCases.enumerated(){
            let label = ruleLabels[index]
            let isMet = !failingError.contains(rule)
            
            if isMet {
                label.text = "✅ " + (rule.errorDescription ?? " ")
                label.textColor = .systemGreen
            }
            else{
                label.text = "x " + (rule.errorDescription ?? " ")
                label.textColor = .systemRed
            }
        }
    }
    
    
    private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()
    
    
    private func keyBoardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let keyBoardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        scrollView.contentInset.bottom = keyBoardFrame.height + 70
        scrollView.verticalScrollIndicatorInsets.bottom = keyBoardFrame.height
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        
        configurePasswordRules()
        
        setAttriputedPlaceHolder("Enter Username", for: usernameTextField)
        setAttriputedPlaceHolder("Enter Email Address", for: emailTextField)
        setAttriputedPlaceHolder("Enter password", for: passwordTextField)
        setAttriputedPlaceHolder("Confirm password", for: confirmPasswordField)
        
        let formStackView = UIStackView(arrangedSubviews: [
            usernameTextField,
            usernameErrorLabel,
            emailTextField,
            emailErrorLabel,
            passwordTextField,
            passwordRuleContainer,
            confirmPasswordField,
            confirmPasswordErrorLabel,
         
            signupButton
        ])
        formStackView.axis = .vertical
        formStackView.spacing = 6
        formStackView.alignment = .fill
        formStackView.isLayoutMarginsRelativeArrangement = true
        
        [usernameErrorLabel, emailErrorLabel,passwordRuleContainer,confirmPasswordErrorLabel].forEach {
            formStackView.setCustomSpacing(14, after: $0)
        }
        
        let contentStackView = UIStackView(arrangedSubviews: [titleLabel,formStackView])
        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.alignment = .fill
        
         let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(contentView)
        contentView.addSubview(contentStackView)
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([

            // scrollView pins to full safe area
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            // contentView fills scrollView width
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            // contentView at minimum fills screen height — allows centering on tall screens
            contentView.heightAnchor.constraint(
                greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor
            ),

            // contentStackView centered vertically with padding — adapts to any height
            contentStackView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor, constant: -20
            ),
            contentStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 28
            ),
            contentStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -28
            ),

            // no fixed heights — use minimum height instead
            usernameTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            emailTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            passwordTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            confirmPasswordField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            signupButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
        
        
    }
    func configureActions() {
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordField.delegate = self
        
        signupButton.addTarget(
            self,
            action: #selector(didTapSignup),
            for: .touchUpInside
        )
        
        emailTextField.addTarget(
            self,
            action: #selector(textDidChange),
            for: .editingChanged
        )
        
        usernameTextField.addTarget(
            self,
            action: #selector(textDidChange),
            for: .editingChanged
        )
        
        passwordTextField.addTarget(
            self,
            action: #selector(passwordFieldDidChange),
            for: .editingChanged
        )
        
        confirmPasswordField.addTarget(
            self,
            action: #selector(passwordFieldDidChange),
            for: .editingChanged
        )

    }
    @objc func passwordFieldDidChange(){
        let password = passwordTextField.text ?? ""
        updatePasswordRules(for: password)
    }
    
    @objc func didTapSignup() {
        presenter?.didTapSignUp(email: emailTextField.text, username: usernameTextField.text, password: passwordTextField.text, confirmPassword: confirmPasswordField.text)
    }
    
    @objc func textDidChange() {
        clearError()
    }
    
    func showError(message: String) {
        clearError()
        
        let lowercasedMessage = message.lowercased()
        
        if lowercasedMessage.contains("username") {
            show(message: message, in: usernameErrorLabel)
        } else if lowercasedMessage.contains("email") || lowercasedMessage.contains("account already exists") {
            show(message: message, in: emailErrorLabel)
        }
        else if lowercasedMessage.contains("do not match") || lowercasedMessage.contains("confirm") {
            show(message: message, in: confirmPasswordErrorLabel)
        }
        else {
            show(message: message, in: emailErrorLabel)
        }
    }
    
    func showSuccess(message: String) {
        clearError()
    }

    private func clearError() {
        [usernameErrorLabel, emailErrorLabel,confirmPasswordErrorLabel].forEach { label in
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

extension SignupView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            if presenter?.didPressReturnOnUsername(usernameTextField.text) == true {
                emailTextField.becomeFirstResponder()
            }
        } else if textField == emailTextField {
            if presenter?.didPressReturnOnEmail(emailTextField.text) == true {
                passwordTextField.becomeFirstResponder()
            }
        } else if textField == passwordTextField {
            if presenter?.didPressReturnOnPassword(passwordTextField.text) == true {
                confirmPasswordField.becomeFirstResponder()
            }
        } else if textField == confirmPasswordField {
            if presenter?.didPressReturnOnConfirmPassword(
                password: passwordTextField.text,
                confirmPassword: confirmPasswordField.text
            ) == true {
                confirmPasswordField.resignFirstResponder()
                didTapSignup()
            }
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return true }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        switch textField {
        case usernameTextField:
            return updatedText.count <= 20
        case emailTextField:
            return updatedText.count <= 40
        case passwordTextField:
            return updatedText.count <= 20
        case confirmPasswordField:
            return updatedText.count <= 20
        default:
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == passwordTextField || textField == confirmPasswordField {
            passwordRuleContainer.isHidden = false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordTextField || textField == confirmPasswordField {
            if !passwordRuleContainer.isHidden {
                passwordRuleContainer.isHidden = true
            }
        }
    }
}
