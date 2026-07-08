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

struct UserVector {
    let temp: AnswersVectorUnit
    let space: AnswersVectorUnit
    let activity: AnswersVectorUnit
    let noise: AnswersVectorUnit
    let social: AnswersVectorUnit
}

class PenguinRecommenerServiceImpl: PenguinRecommenerService {
    
    private let penguinsBreedsList: [Breed]
    
    init(penguinsBreedsList: [Breed]) {
        self.penguinsBreedsList = penguinsBreedsList
    }
    
    // если вернулся nil - подходящего пингвина не нашлось
    func recommenedPenguin(answers: [QuizAnswer]) -> Breed? {
        let vector = UserVector(
            temp: AnswersVectorUnit(value: answers[0].value, weight: answers[0].weight),
            space: AnswersVectorUnit(value: answers[1].value, weight: answers[1].weight),
            activity: AnswersVectorUnit(value: answers[2].value, weight: answers[2].weight),
            noise: AnswersVectorUnit(value: answers[3].value, weight: answers[3].weight),
            social: AnswersVectorUnit(value: answers[4].value, weight: answers[4].weight)
        )
        
        return getMostSuitableBreed(vector: vector)
    }
    
    private func getMostSuitableBreed(vector: UserVector) -> Breed? {
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
            
            // не берем арктических пингвинов для людей, живущих в тропиках
            !(vector.temp.value >= 9 && breed.mathParams.temp <= 3) &&
            
            // не берем больших пингвинов в маленькое жилье
            !(vector.space.value <= 2 && breed.mathParams.space >= 5) &&
            
            // не выдаем спокойным людям активных пингвинов
            !(vector.activity.value <= 5 && breed.mathParams.activity >= 5) &&
            
            // не отдаем шумных пингвинов людям, любящим тишину
            !(vector.noise.value <= 3 && breed.mathParams.noise >= 5) &&
            
            // не отдаем социальных пингвинов интровертам
            !(vector.social.value <= 3 && breed.mathParams.social >= 6)
        }
    }
}
