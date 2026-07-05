//
//  Penguin.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Егор Бессонов on 05.07.2026.
//

struct PenguinsData: Decodable {
    let breeds: [Breed]
}

// MARK: - Порода
struct Breed: Decodable {
    let id: Int
    let name: String
    let mathParams: MathParams
    let limits: Limits
    let userInfo: UserInfo
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case mathParams = "math_params"
        case limits
        case userInfo = "user_info"
    }
}

// MARK: - Математические параметры (для расчётов)
struct MathParams: Decodable {
    let temp: Int          // 0-10
    let space: Int         // 0-10
    let activity: Int      // 0-10
    let noise: Int         // 0-10
    let social: Int        // 0-10
}

// MARK: - Жёсткие ограничения (для фильтрации)
struct Limits: Decodable {
    let minTemperature: Double
    let maxTemperature: Double
    let minSpaceSqm: Int
    let minGroupSize: Int
    let maxGroupSize: Int
    
    enum CodingKeys: String, CodingKey {
        case minTemperature = "min_temperature"
        case maxTemperature = "max_temperature"
        case minSpaceSqm = "min_space_sqm"
        case minGroupSize = "min_group_size"
        case maxGroupSize = "max_group_size"
    }
}

// MARK: - Информация для пользователя
struct UserInfo: Decodable {
    let scientificName: String
    let size: String
    let heightCm: Int
    let weightKg: Double
    let lifespanYears: Int
    let description: String
    let careTips: String
    let pros: [String]
    let cons: [String]
    let diet: String
    let imageUrl: String
    let funFact: String
    
    enum CodingKeys: String, CodingKey {
        case scientificName = "scientific_name"
        case size
        case heightCm = "height_cm"
        case weightKg = "weight_kg"
        case lifespanYears = "lifespan_years"
        case description
        case careTips = "care_tips"
        case pros
        case cons
        case diet
        case imageUrl = "image_url"
        case funFact = "fun_fact"
    }
}

// MARK: - Расширение для удобства работы
extension Breed {
    var mathVector: [Int] {
        return [
            mathParams.temp,
            mathParams.space,
            mathParams.activity,
            mathParams.noise,
            mathParams.social
        ]
    }
}


