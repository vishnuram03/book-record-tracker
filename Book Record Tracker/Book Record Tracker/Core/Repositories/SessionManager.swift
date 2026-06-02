import Foundation

protocol SessionManaging {
    var currentUserId: Int? { get }
    var isLoggedIn: Bool { get }

    func saveSession(userId: Int)
    func clearSession()
}

final class SessionManager: SessionManaging {
    static let shared = SessionManager()

    private let userDefaults: UserDefaults
    private let currentUserIdKey = "current_user_id"

    var currentUserId: Int? {
        let value = userDefaults.integer(forKey: currentUserIdKey)
        return value == 0 ? nil : value
    }

    var isLoggedIn: Bool {
        currentUserId != nil
    }

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func saveSession(userId: Int) {
        userDefaults.set(userId, forKey: currentUserIdKey)
    }

    func clearSession() {
        userDefaults.removeObject(forKey: currentUserIdKey)
    }
}
