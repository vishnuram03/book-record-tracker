import Foundation

enum AuthValidationError: LocalizedError {
    case emptyUsername
    case invalidEmail
    case weakPassword
    case emptyPassword

    var errorDescription: String? {
        switch self {
        case .emptyUsername:
            return "Please enter a username."
        case .invalidEmail:
            return "Please enter a valid email address."
        case .weakPassword:
            return "Password must be at least 8 characters and include a number."
        case .emptyPassword:
            return "Please enter your password."
        }
    }
}

enum AuthValidator {
    static func normalizedEmail(_ email: String) -> String {
        email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    static func validateSignup(username: String, email: String, password: String) throws {
        guard !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AuthValidationError.emptyUsername
        }

        try validateEmail(email)
        try validatePasswordStrength(password)
    }

    static func validateLogin(email: String, password: String) throws {
        try validateEmail(email)

        guard !password.isEmpty else {
            throw AuthValidationError.emptyPassword
        }
    }

    private static func validateEmail(_ email: String) throws {
        let normalized = normalizedEmail(email)
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#

        guard normalized.range(of: pattern, options: .regularExpression) != nil else {
            throw AuthValidationError.invalidEmail
        }
    }

    private static func validatePasswordStrength(_ password: String) throws {
        let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil

        guard password.count >= 8, hasNumber else {
            throw AuthValidationError.weakPassword
        }
    }
}
