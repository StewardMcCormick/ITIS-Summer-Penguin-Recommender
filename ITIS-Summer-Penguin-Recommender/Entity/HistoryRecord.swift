//
//  HistoryRecord.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Элиза Азатовна on 08.07.2026.
//

import Foundation

// MARK: - Модель записи истории
struct HistoryRecord: Codable, Identifiable {
    let id: UUID
    let date: Date
    let breedId: Int
    let breedName: String
    let userAnswers: [String: Int]
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        breedId: Int,
        breedName: String,
        userAnswers: [String: Int]
    ) {
        self.id = id
        self.date = date
        self.breedId = breedId
        self.breedName = breedName
        self.userAnswers = userAnswers
    }
}
