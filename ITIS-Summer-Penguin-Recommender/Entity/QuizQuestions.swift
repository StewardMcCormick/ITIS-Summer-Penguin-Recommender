import Foundation

// MARK: - Анкета
struct Quiz: Decodable {
    let questions: [Question]
    let metadata: Metadata
}

// MARK: - Вопрос
struct Question: Decodable {
    let id: Int
    let question: String
    let type: String
    let answers: [Answer]
}

// MARK: - Ответ
struct Answer: Decodable {
    let id: String
    let label: String
    let value: Int
    let weight: Double
}

// MARK: - Метаданные
struct Metadata: Decodable {
    let totalQuestions: Int
    let version: String
    let title: String
    let subtitle: String
    
    enum CodingKeys: String, CodingKey {
        case totalQuestions = "total_questions"
        case version
        case title
        case subtitle
    }
}
