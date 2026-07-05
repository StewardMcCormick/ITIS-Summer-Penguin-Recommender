//
//  PenguinStorage.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Егор Бессонов on 05.07.2026.
//

import Foundation

protocol PenguinStorage {
    func getPenguinsData() -> PenguinsData?
}

class JSONPenguinStorage: PenguinStorage {
    
    private let jsonFilename: String
    
    private var penguinsData: PenguinsData? = nil
    
    init(jsonFilename: String) {
        self.jsonFilename = jsonFilename
    }
    
    func getPenguinsData() -> PenguinsData? {
        if let cached = penguinsData {
            return cached
        }
        
        guard let fileUrl = Bundle.main.url(forResource: jsonFilename, withExtension: "json")
        else {
            print("Файл \(jsonFilename).json не найден в папке penguin_info")
            return nil
        }
        
        do {
            let jsonData = try Data(contentsOf: fileUrl)
            let result = try JSONDecoder().decode(PenguinsData.self, from: jsonData)
            penguinsData = result
            return result
        } catch {
            print("Ошибка загрузки или декодирования: \(error)")
            return nil
        }
    }
}
