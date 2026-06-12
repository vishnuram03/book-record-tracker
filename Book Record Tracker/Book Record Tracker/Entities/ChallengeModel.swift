import Foundation

enum ChallengeType: String, CaseIterable {
    case dailyPages = "Daily Pages"
    case monthlyBooks = "Monthly Books"
    case streak = "Streak"
}

enum ChallengeStatus: String, CaseIterable {
    case active = "Active"
    case completed = "Completed"
    case failed = "Failed"
}

final class ChallengeModel: DatabaseModel {
    static let tableName = "challenges"
    static let primaryKey = ChallengeColumn.challengeId

    var id: Int?
    var userId: Int
    var title: String
    var bookId: Int?
    var challengeDescription: String
    var targetValue: Int
    var currentValue: Int
    var challengeType: String
    var status: String
    var startDate: String
    var endDate: String

    var progressPercentage: Double {
        guard targetValue > 0 else { return 0 }
        return min(Double(currentValue) / Double(targetValue) * 100, 100)
    }
    
    enum ChallengeColumn {
        static let challengeId = "challenge_id"
        static let userId = "user_id"
        static let bookId = "book_id"
        static let title = "title"
        static let description = "description"
        static let targetValue = "target_value"
        static let currentValue = "current_value"
        static let challengeType = "challenge_type"
        static let status = "status"
        static let startDate = "start_date"
        static let endDate = "end_date"
    }

    init(
        id: Int? = nil,
        userId: Int,
        title: String,
        bookId: Int? = nil,
        challengeDescription: String = "",
        targetValue: Int,
        currentValue: Int = 0,
        challengeType: String,
        status: String = ChallengeStatus.active.rawValue,
        startDate: String,
        endDate: String
    ) {
        self.id = id
        self.userId = userId
        self.title = title
        self.bookId = bookId
        self.challengeDescription = challengeDescription
        self.targetValue = targetValue
        self.currentValue = currentValue
        self.challengeType = challengeType
        self.status = status
        self.startDate = startDate
        self.endDate = endDate
    }

    static func columnDefinitions() -> [(String, DatabaseColumnType)] {
        [
            (ChallengeColumn.challengeId, .integer),
            (ChallengeColumn.userId, .integer),
            (ChallengeColumn.bookId, .integer),
            (ChallengeColumn.title, .text),
            (ChallengeColumn.description, .text),
            (ChallengeColumn.targetValue, .integer),
            (ChallengeColumn.currentValue, .integer),
            (ChallengeColumn.challengeType, .text),
            (ChallengeColumn.status, .text),
            (ChallengeColumn.startDate, .text),
            (ChallengeColumn.endDate, .text)
        ]
    }

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            ChallengeColumn.userId: userId,
            ChallengeColumn.title: title,
            ChallengeColumn.description: challengeDescription,
            ChallengeColumn.targetValue: targetValue,
            ChallengeColumn.currentValue: currentValue,
            ChallengeColumn.challengeType: challengeType,
            ChallengeColumn.status: status,
            ChallengeColumn.startDate: startDate,
            ChallengeColumn.endDate: endDate
        ]

        if let id {
            dict[ChallengeColumn.challengeId] = id
        }

        if let bookId {
            dict[ChallengeColumn.bookId] = bookId
        }

        return dict
    }

    static func fromDictionary(_ dict: [String: Any]) -> ChallengeModel? {
        guard
            let id = dict[ChallengeColumn.challengeId] as? Int,
            let userId = dict[ChallengeColumn.userId] as? Int,
            let title = dict[ChallengeColumn.title] as? String,
            let targetValue = dict[ChallengeColumn.targetValue] as? Int,
            let challengeType = dict[ChallengeColumn.challengeType] as? String,
            let status = dict[ChallengeColumn.status] as? String,
            let startDate = dict[ChallengeColumn.startDate] as? String,
            let endDate = dict[ChallengeColumn.endDate] as? String
        else {
            return nil
        }

        return ChallengeModel(
            id: id,
            userId: userId,
            title: title,
            bookId: dict[ChallengeColumn.bookId] as? Int,
            challengeDescription: dict[ChallengeColumn.description] as? String ?? "",
            targetValue: targetValue,
            currentValue: dict[ChallengeColumn.currentValue] as? Int ?? 0,
            challengeType: challengeType,
            status: status,
            startDate: startDate,
            endDate: endDate
        )
    }
}
