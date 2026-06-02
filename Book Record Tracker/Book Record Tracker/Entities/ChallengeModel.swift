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
    static let primaryKey = "id"

    var id: Int?
    var userId: Int
    var title: String
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

    init(
        id: Int? = nil,
        userId: Int,
        title: String,
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
            ("id", .integer),
            ("user_id", .integer),
            ("title", .text),
            ("description", .text),
            ("target_value", .integer),
            ("current_value", .integer),
            ("challenge_type", .text),
            ("status", .text),
            ("start_date", .text),
            ("end_date", .text)
        ]
    }

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "user_id": userId,
            "title": title,
            "description": challengeDescription,
            "target_value": targetValue,
            "current_value": currentValue,
            "challenge_type": challengeType,
            "status": status,
            "start_date": startDate,
            "end_date": endDate
        ]

        if let id {
            dict["id"] = id
        }

        return dict
    }

    static func fromDictionary(_ dict: [String: Any]) -> ChallengeModel? {
        guard
            let id = dict["id"] as? Int,
            let userId = dict["user_id"] as? Int,
            let title = dict["title"] as? String,
            let targetValue = dict["target_value"] as? Int,
            let challengeType = dict["challenge_type"] as? String,
            let status = dict["status"] as? String,
            let startDate = dict["start_date"] as? String,
            let endDate = dict["end_date"] as? String
        else {
            return nil
        }

        return ChallengeModel(
            id: id,
            userId: userId,
            title: title,
            challengeDescription: dict["description"] as? String ?? "",
            targetValue: targetValue,
            currentValue: dict["current_value"] as? Int ?? 0,
            challengeType: challengeType,
            status: status,
            startDate: startDate,
            endDate: endDate
        )
    }
}
