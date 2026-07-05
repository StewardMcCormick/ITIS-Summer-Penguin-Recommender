//
//  PenguinRecommenerService.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Егор Бессонов on 05.07.2026.
//

import Foundation

protocol PenguinRecommenerService {
    func recommenedPenguin(answers: [QuizAnswer]) -> Breed?
}

struct AnswersVectorUnit {
    let value: Int
    let weight: Double
}

class PenguinRecommenerServiceImpl: PenguinRecommenerService {
    
    private let penguinsBreedsList: [Breed]
    
    init(penguinsBreedsList: [Breed]) {
        self.penguinsBreedsList = penguinsBreedsList
    }
    
    // MARK: если вернулся nil - подходящего пингвина не нашлось
    func recommenedPenguin(answers: [QuizAnswer]) -> Breed? {
        return getMostSuitableBreed(vector: parseAnswersVector(answers: answers))
    }
    
    private func parseAnswersVector(answers: [QuizAnswer]) -> [AnswersVectorUnit] {
        var resultVector: [AnswersVectorUnit] = []
        
        for a in answers {
            resultVector.append(AnswersVectorUnit(value: a.value, weight: a.weight))
        }
        
        return resultVector
    }
    
    private func getMostSuitableBreed(vector: [AnswersVectorUnit]) -> Breed? {
        var filteredBreeds = getFilteredBreedsByHardCondition(vector: vector)
        
        if filteredBreeds.isEmpty {
            return nil
        }
        
        var breedToDistanceMap: [Breed:Double] = [:]
        for breed in filteredBreeds {
            let diffTemp = Double(vector[0].value - breed.mathParams.temp)
            let diffSpace = Double(vector[1].value - breed.mathParams.space)
            let diffActivity = Double(vector[2].value - breed.mathParams.activity)
            let diffNoise = Double(vector[3].value - breed.mathParams.noise)
            let diffSocial = Double(vector[4].value - breed.mathParams.social)
            
            let weightedDiffTemp = diffTemp * diffTemp * vector[0].weight
            let weightedDiffSpace = diffSpace * diffSpace * vector[1].weight
            let weightedDiffActivity = diffActivity * diffActivity * vector[2].weight
            let weightedDiffNoise = diffNoise * diffNoise * vector[3].weight
            let weightedDiffSocial = diffSocial * diffSocial * vector[4].weight
                
            
            let weightedSum = weightedDiffTemp + weightedDiffSpace + weightedDiffActivity + weightedDiffNoise + weightedDiffSocial
            let distance = sqrt(weightedSum)
                
            breedToDistanceMap[breed] = distance
        }
        
        return breedToDistanceMap.min {
            return $0.value < $1.value
        }?.key
    }
    
    private func getFilteredBreedsByHardCondition(vector: [AnswersVectorUnit]) -> [Breed] {
        var result: [Breed] = []
        
        for breed in penguinsBreedsList {
            
            // MARK: не берем арктических пингвинов для людей, живущих в тропиках
            if vector[0].value >= 9 && breed.mathParams.temp <= 3 {
                continue
            }
            
            // MARK: не берем больших пингвинов в маленькое жилье
            if vector[1].value <= 2 && breed.mathParams.space >= 5 {
                continue
            }
            
            // MARK: не выдаем спокойным людям активных пингвинов
            if vector[2].value <= 5 && breed.mathParams.activity >= 5 {
                continue
            }
            
            // MARK: не отдаем шумных пингвинов людям, любящим тишину
            if vector[3].value <= 3 && breed.mathParams.noise >= 5 {
                continue
            }
            
            // MARK: не отдаем социальных пингвинов интровертам
            if vector[4].value <= 3 && breed.mathParams.social >= 6 {
                continue
            }
            
            result.append(breed)
        }
        
        return result
    }
}
