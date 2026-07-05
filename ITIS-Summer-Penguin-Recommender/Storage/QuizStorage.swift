//
//  QuizStorage.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Егор Бессонов on 05.07.2026.
//

import Foundation

protocol QuizStorage {
    func getAllQuestions() -> [Question]
    
    func getQuizMetadata() -> Metadata
}

class JSONQuizStorage: QuizStorage {
    private let jsonFilename: String
    
    private var quiz: Quiz
    
    init(jsonFilename: String) {
        self.jsonFilename = jsonFilename
        
        let fileUrl = Bundle.main.url(forResource: jsonFilename, withExtension: "json")
        
        let jsonData = try! Data(contentsOf: fileUrl!)
        let result = try! JSONDecoder().decode(Quiz.self, from: jsonData)
        quiz = result
    }
    
    func getAllQuestions() -> [Question] {
        return quiz.questions
    }
    
    func getQuizMetadata() -> Metadata {
        return quiz.metadata
    }
}
