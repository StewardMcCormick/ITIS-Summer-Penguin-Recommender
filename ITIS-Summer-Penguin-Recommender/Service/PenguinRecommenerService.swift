//
//  PenguinRecommenerService.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Егор Бессонов on 05.07.2026.
//

import Foundation
import SwiftUI

protocol PenguinRecommenerService {
    func recommenedPenguin(answers: [QuizAnswer]) -> Breed?
    func setUserPhoto(photo: Data)
}

struct AnswersVectorUnit {
    let value: Int
    let weight: Double
}

struct UserVector {
    let temp: AnswersVectorUnit
    let space: AnswersVectorUnit
    let activity: AnswersVectorUnit
    let noise: AnswersVectorUnit
    let social: AnswersVectorUnit
}

class PenguinRecommenerServiceImpl: PenguinRecommenerService {
    
    private let userPhotoAnalizeService: UserPhotoAnalizeService
    private let penguinsBreedsList: [Breed]
    private var userPhoto: Data? = nil
    
    init(userPhotoAnalizeService: UserPhotoAnalizeService, penguinsBreedsList: [Breed]) {
        self.userPhotoAnalizeService = userPhotoAnalizeService
        self.penguinsBreedsList = penguinsBreedsList
    }
    
    func recommenedPenguin(answers: [QuizAnswer]) -> Breed? {
        let vector = UserVector(
            temp: AnswersVectorUnit(value: answers[0].value, weight: answers[0].weight),
            space: AnswersVectorUnit(value: answers[1].value, weight: answers[1].weight),
            activity: AnswersVectorUnit(value: answers[2].value, weight: answers[2].weight),
            noise: AnswersVectorUnit(value: answers[3].value, weight: answers[3].weight),
            social: AnswersVectorUnit(value: answers[4].value, weight: answers[4].weight)
        )
        
        if let userPhoto = userPhoto {
            return getMostSuitableBreedWithPhoto(vector: vector, photo: userPhoto)
        }
        
        return getMostSuitableBreedWithoutPhoto(vector: vector)
    }
    
    func setUserPhoto(photo: Data) {
        userPhoto = photo
    }
    
    private func getMostSuitableBreedWithPhoto(vector: UserVector, photo: Data) -> Breed? {
        let breedWithoutPhoto = getMostSuitableBreedWithoutPhoto(vector: vector)
        if let breedWithoutPhoto = breedWithoutPhoto {
            return PenguinComparisonService.compareCritical(
                breedFromQuiz: breedWithoutPhoto,
                breedFromPhoto: userPhotoAnalizeService.analize(photo: photo)
            )
        }
        
        return nil
    }
    
    private func getMostSuitableBreedWithoutPhoto(vector: UserVector) -> Breed? {
        let filteredBreeds = getFilteredBreedsByHardCondition(vector: vector)
        
        if filteredBreeds.isEmpty {
            return nil
        }
        
        var breedToDistanceMap: [Breed:Double] = [:]
        for breed in filteredBreeds {
            let diffTemp = Double(vector.temp.value - breed.mathParams.temp)
            let diffSpace = Double(vector.space.value - breed.mathParams.space)
            let diffActivity = Double(vector.activity.value - breed.mathParams.activity)
            let diffNoise = Double(vector.noise.value - breed.mathParams.noise)
            let diffSocial = Double(vector.social.value - breed.mathParams.social)
            
            let weightedDiffTemp = diffTemp * diffTemp * vector.temp.weight
            let weightedDiffSpace = diffSpace * diffSpace * vector.space.weight
            let weightedDiffActivity = diffActivity * diffActivity * vector.activity.weight
            let weightedDiffNoise = diffNoise * diffNoise * vector.noise.weight
            let weightedDiffSocial = diffSocial * diffSocial * vector.social.weight
                
            
            let weightedSum = weightedDiffTemp + weightedDiffSpace + weightedDiffActivity + weightedDiffNoise + weightedDiffSocial
            let distance = sqrt(weightedSum)
                
            breedToDistanceMap[breed] = distance
        }
        
        return breedToDistanceMap.min {
            return $0.value < $1.value
        }?.key
    }
    
    private func getFilteredBreedsByHardCondition(vector: UserVector) -> [Breed] {
        return penguinsBreedsList.filter { breed in
            
            !(vector.temp.value >= 9 && breed.mathParams.temp <= 3) &&   // ← было 7, стало 3
            
            !(vector.space.value <= 2 && breed.mathParams.space >= 5) &&
            
            !(vector.activity.value <= 2 && breed.mathParams.activity >= 8) &&
            
            !(vector.noise.value <= 2 && breed.mathParams.noise >= 8) &&
            
            !(vector.social.value <= 2 && breed.mathParams.social >= 8)
        }
    }
}


// MARK: - Сервис сравнения (только критические параметры)
class PenguinComparisonService {
    
    private static let similarityThreshold: Double = 70.0
    
    private static let criticalWeights: [String: Double] = [
        "temp": 1.0,
        "space": 1.0
    ]
    
    static func compareCritical(breedFromQuiz: Breed, breedFromPhoto: Breed) -> Breed {
        let diffTemp = Double(abs(breedFromQuiz.mathParams.temp - breedFromPhoto.mathParams.temp))
        let diffSpace = Double(abs(breedFromQuiz.mathParams.space - breedFromPhoto.mathParams.space))
        
        let maxDiff = 10.0
        
        let similarityTemp = max(0, 100 - (diffTemp / maxDiff) * 100) * criticalWeights["temp"]!
        let similaritySpace = max(0, 100 - (diffSpace / maxDiff) * 100) * criticalWeights["space"]!
        
        let totalWeight = criticalWeights.values.reduce(0, +)
        let totalSimilarity = (similarityTemp + similaritySpace) / totalWeight
                
        if totalSimilarity >= similarityThreshold {
            return breedFromPhoto
        }
        
        return breedFromQuiz
    }
}
