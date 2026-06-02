import Foundation

enum UserRepositoryError: LocalizedError {
    case emailAlreadyExists
    case invalidCredentials
    case saveFailed

    var errorDescription: String? {
        switch self {
        case .emailAlreadyExists:
            return "An account already exists with this email."
        case .invalidCredentials:
            return "The email or password is incorrect."
        case .saveFailed:
            return "Could not save the account. Please try again."
        }
    }
}

protocol UserRepositoryProtocol {
    func signup(username: String, email: String, password: String) throws -> UserModel
    func login(email: String, password: String) throws -> UserModel
    func user(withId id: Int) -> UserModel?
    func userExists(email: String) -> Bool
}

final class UserRepository: UserRepositoryProtocol {
    private let database: DatabaseManager

    init(database: DatabaseManager = .shared) {
        self.database = database
    }

    func signup(username: String, email: String, password: String) throws -> UserModel {
        try AuthValidator.validateSignup(username: username, email: email, password: password)

        let normalizedEmail = AuthValidator.normalizedEmail(email)

        guard !userExists(email: normalizedEmail) else {
            throw UserRepositoryError.emailAlreadyExists
        }

        let user = UserModel(
            username: username.trimmingCharacters(in: .whitespacesAndNewlines),
            emailId: normalizedEmail,
            password: PasswordHasher.hash(password)
        )

        guard database.insert(user) else {
            throw UserRepositoryError.saveFailed
        }

        let insertedId = database.lastInsertedId()
        user.id = insertedId
        return user
    }

    func login(email: String, password: String) throws -> UserModel {
        try AuthValidator.validateLogin(email: email, password: password)

        let normalizedEmail = AuthValidator.normalizedEmail(email)
        let passwordHash = PasswordHasher.hash(password)
        let users = database.searchWhere(
            UserModel.self,
            where: [
                "email_id": normalizedEmail,
                "password": passwordHash
            ]
        )

        guard let user = users.first else {
            throw UserRepositoryError.invalidCredentials
        }

        return user
    }

    func user(withId id: Int) -> UserModel? {
        database.searchWhere(UserModel.self, where: ["id": id]).first
    }

    func userExists(email: String) -> Bool {
        let normalizedEmail = AuthValidator.normalizedEmail(email)
        return !database.searchWhere(UserModel.self, where: ["email_id": normalizedEmail]).isEmpty
    }
}
