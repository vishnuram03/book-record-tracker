//
//  BookJson.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 11/06/26.
//

import Foundation

struct BookJSON: Codable {
    let id: Int?
    let isbn: String?
    let bookName: String
    let author: String
    let bookDescription: String
    let genre: [String]
    let totalPages: Int
    let coverImagePath: String?
    
    func toBookModel() -> BookModel? {
        let genres = genre.compactMap { Genre(rawValue: $0) }
        guard !genres.isEmpty else { return nil }
        
        return BookModel(
            isbn: isbn,
            bookName: bookName,
            author: author,
            bookDescription: bookDescription,
            genre: genres,
            totalPages: totalPages,
            coverImagePath: coverImagePath
        )
    }
}
