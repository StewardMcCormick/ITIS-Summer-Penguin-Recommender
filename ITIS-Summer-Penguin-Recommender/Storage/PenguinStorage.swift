//
//  PenguinStorage.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Егор Бессонов on 05.07.2026.
//

import Foundation

enum PenguinStorageError: Error {
    case fileNotFound
    case decodingError(Error)
}

protocol PenguinStorage {
    func getPenguinsData() throws -> PenguinsData
}

class JSONPenguinStorage: PenguinStorage {
    
    private let jsonFilename: String
    
    private var penguinsData: PenguinsData? = nil
    
    init(jsonFilename: String) {
        self.jsonFilename = jsonFilename
    }
    
    func getPenguinsData() throws -> PenguinsData {
        if let cached = penguinsData {
            return cached
        }
        
        guard let fileUrl = Bundle.main.url(forResource: jsonFilename, withExtension: "json")
        else {
            throw PenguinStorageError.fileNotFound
        }
        
        do {
            let jsonData = try Data(contentsOf: fileUrl)
            let result = try JSONDecoder().decode(PenguinsData.self, from: jsonData)
            penguinsData = result
            return result
        } catch {
            throw PenguinStorageError.decodingError(error)
        }
    }
}
