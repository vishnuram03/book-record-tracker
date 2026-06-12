import Foundation

enum AuthValidationError: LocalizedError {
    case emptyUsername
    case invalidEmail
    case emptyPassword
    case passwordTooShort        // less than 8 characters
    case passwordMissingUppercase // no uppercase letter
    case passwordMissingLowercase // no lowercase letter
    case passwordMissingNumber    // no number

    var errorDescription: String? {
        switch self {
        case .emptyUsername:
            return "Please enter a username."
        case .invalidEmail:
            return "Please enter a valid email address."
        case .emptyPassword:
            return "Please enter your password."
        case .passwordTooShort:
            return "Password must be at least 8 characters."
        case .passwordMissingUppercase:
            return "Password must include at least one uppercase letter."
        case .passwordMissingLowercase:
            return "Password must include at least one lowercase letter."
        case .passwordMissingNumber:
            return "Password must include at least one number."
        }
    }
}

enum AuthValidator {
    static func normalizedEmail(_ email: String) -> String {
        email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    static func validateSignup(username: String, email: String, password: String) throws {
        try validateUsername(username)
        try validateEmail(email)
        try validatePasswordStrength(password)
    }

    static func validateLogin(email: String, password: String) throws {
        try validateEmail(email)

        guard !password.isEmpty else {
            throw AuthValidationError.emptyPassword
        }
    }

    static func validateUsername(_ username: String) throws {
        guard !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AuthValidationError.emptyUsername
        }
    }

    static func validateEmail(_ email: String) throws {
        let normalized = normalizedEmail(email)
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#

        guard normalized.range(of: pattern, options: .regularExpression) != nil else {
            throw AuthValidationError.invalidEmail
        }
    }

    static func validatePasswordStrength(_ password: String) throws {
            guard password.count >= 8 else {
                throw AuthValidationError.passwordTooShort
            }
            guard password.rangeOfCharacter(from: .uppercaseLetters) != nil else {
                throw AuthValidationError.passwordMissingUppercase
            }
            guard password.rangeOfCharacter(from: .lowercaseLetters) != nil else {
                throw AuthValidationError.passwordMissingLowercase
            }
            guard password.rangeOfCharacter(from: .decimalDigits) != nil else {
                throw AuthValidationError.passwordMissingNumber
            }
    }
    
    static func passwordErrors(for password: String) -> [AuthValidationError] {
        var errors: [AuthValidationError] = []
        
        if password.count < 8 {
            errors.append(.passwordTooShort)
        }
        
        if password.rangeOfCharacter(from: .uppercaseLetters) == nil {
            errors.append(.passwordMissingUppercase)
        }
        
        if password.rangeOfCharacter(from: .lowercaseLetters) == nil {
            errors.append(.passwordMissingLowercase)
        }
        if password.rangeOfCharacter(from: .decimalDigits) == nil {
            errors.append(.passwordMissingNumber)
        }
        return errors
    }
    
}
