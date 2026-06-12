//
//  PreferenceRepository.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 04/06/26.
//

import Foundation

enum PreferenceRepositoryError: LocalizedError {
    case saveFailed

    var errorDescription: String? {
        switch self {
        case .saveFailed:
            return "Could not save preferences. Please try again."
        }
    }
}

protocol PreferenceRepositoryProtocol {
    func savePreference(userId: Int, preferredGenres: [String], preferredSize: String, preferredAuthor: [String]) throws
    func fetchPreference(userId: Int) -> PreferenceModel?
}

final class PreferenceRepository: PreferenceRepositoryProtocol {
    static let shared = PreferenceRepository()

    private let database: DatabaseManager

    init(database: DatabaseManager = .shared) {
        self.database = database
    }

    func savePreference(userId: Int, preferredGenres: [String], preferredSize: String, preferredAuthor: [String]) throws {
        let existingPreference = fetchPreference(userId: userId)
        let preference = PreferenceModel(
            id: existingPreference?.id,
            userId: userId,
            preferredGenres: preferredGenres,
            preferredSize: preferredSize,
            preferredAuthor: preferredAuthor
        )

        let didSave: Bool
        if existingPreference == nil {
            didSave = database.insert(preference)
        } else {
            didSave = database.update(preference)
        }
        print("Attempting to save preference for userId: \(userId)")
        print("Genres: \(preferredGenres)")
        print("Size: \(preferredSize)")
        print("didSave result: \(didSave)")

        guard didSave else {
            throw PreferenceRepositoryError.saveFailed
        }
    }

    func fetchPreference(userId: Int) -> PreferenceModel? {
        database.fetchWhere(
            PreferenceModel.self,
            where: [PreferenceModel.PreferenceColumn.userId: userId]
        ).first
    }
}
