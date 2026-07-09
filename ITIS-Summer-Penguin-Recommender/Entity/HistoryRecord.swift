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
    let isPenguinRecommended: Bool
    let breedId: Int?
    let recordTitle: String
    let userAnswers: [String: Int]
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        isPenguinRecommended: Bool,
        breedId: Int?,
        recordTitle: String,
        userAnswers: [String: Int]
    ) {
        self.id = id
        self.date = date
        self.isPenguinRecommended = isPenguinRecommended
        self.breedId = breedId
        self.recordTitle = recordTitle
        self.userAnswers = userAnswers
    }
}
