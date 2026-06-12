import Foundation

enum UserRepositoryError: LocalizedError {
    case emailAlreadyExists
    case noSuchEmailExixsts
    case invalidPassword
    case saveFailed

    var errorDescription: String? {
        switch self {
        case .emailAlreadyExists:
            return "An account already exists with this email."
        case .noSuchEmailExixsts:
            return "No user exists with this email."
        case .invalidPassword:
            return "The password is incorrect."
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
    static let shared = UserRepository()
    
    private let database: DatabaseManager

    init(database: DatabaseManager = .shared) {
        self.database = database
    }

    func signup(username: String, email: String, password: String) throws -> UserModel {

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

        let normalizedEmail = AuthValidator.normalizedEmail(email)
        let passwordHash = PasswordHasher.hash(password)
        
        guard userExists(email: normalizedEmail) else {
            throw UserRepositoryError.noSuchEmailExixsts
        }
        
        let users = database.fetchWhere(
            UserModel.self,
            where: [
                UserModel.UserColumn.emailId: normalizedEmail,
                UserModel.UserColumn.password: passwordHash
            ]
        )

        guard let user = users.first else {
            throw UserRepositoryError.invalidPassword
        }

        return user
    }

    func user(withId id: Int) -> UserModel? {
        database.fetchWhere(UserModel.self, where: [UserModel.UserColumn.userId: id]).first
    }

    func userExists(email: String) -> Bool {
        let normalizedEmail = AuthValidator.normalizedEmail(email)
        return !database.fetchWhere(UserModel.self, where: [UserModel.UserColumn.emailId: normalizedEmail]).isEmpty
    }
}
