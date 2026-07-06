//
//  QuizStorage.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Егор Бессонов on 05.07.2026.
//

import Foundation

enum QuizStorageError: Error {
    case fileNotFound
    case decodingError(Error)
}

protocol QuizStorage {
    func getAllQuestions() throws -> [Question]
    
    func getQuizMetadata() throws -> Metadata
}

class JSONQuizStorage: QuizStorage {
    private let jsonFilename: String
    
    private var quiz: Quiz?
    
    init(jsonFilename: String) {
        self.jsonFilename = jsonFilename
    }
    
    private func loadQuiz() throws -> Quiz {
        guard let fileUrl = Bundle.main.url(forResource: jsonFilename, withExtension: "json") else {
            throw QuizStorageError.fileNotFound
        }
        
        let jsonData = try Data(contentsOf: fileUrl)
        return try JSONDecoder().decode(Quiz.self, from: jsonData)
    }
    
    func getAllQuestions() throws -> [Question] {
        if let cached = quiz {
            return cached.questions
        }
        
        let loadedQuiz = try loadQuiz()
        quiz = loadedQuiz
        return loadedQuiz.questions
    }
    
    func getQuizMetadata() throws -> Metadata {
        if let cached = quiz {
            return cached.metadata
        }
        
        let loadedQuiz = try loadQuiz()
        quiz = loadedQuiz
        return loadedQuiz.metadata
    }
}
