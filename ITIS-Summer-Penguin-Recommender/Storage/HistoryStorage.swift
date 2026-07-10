//
//  HistoryStorage.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Элиза Азатовна on 08.07.2026.
//

import Foundation

// MARK: - Хранилище истории
class HistoryStorage {
    
    private let userId: UUID
    private var historyKey: String { "penguinHistory_\(userId.uuidString)" }
        
    init(userId: UUID) {
        self.userId = userId
    }
    
    func save(record: HistoryRecord) {
        var records = getAllRecords()
        records.append(record)
        
        if let data = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(data, forKey: historyKey)
        }
    }
    
    func getAllRecords() -> [HistoryRecord] {
        guard let data = UserDefaults.standard.data(forKey: historyKey),
              let records = try? JSONDecoder().decode([HistoryRecord].self, from: data) else {
            return []
        }
        return records.sorted { $0.date > $1.date }
    }
    
    func deleteRecord(id: UUID) {
        var records = getAllRecords()
        records.removeAll { $0.id == id }
        
        if let data = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(data, forKey: historyKey)
        }
    }
    
    func clearAll() {
        UserDefaults.standard.removeObject(forKey: historyKey)
    }
}
