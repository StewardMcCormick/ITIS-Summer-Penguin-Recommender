//
//  UserPhotoAnalizeService.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Егор Бессонов on 10.07.2026.
//

import Foundation

protocol UserPhotoAnalizeService {
    func analize(photo: Data) -> Breed
}

class RandomUserPhotoAnalizeService: UserPhotoAnalizeService {
    
    private let penguinsBreedsList: [Breed]
    
    init(penguinsBreedsList: [Breed]) {
        self.penguinsBreedsList = penguinsBreedsList
    }
    
    func analize(photo: Data) -> Breed {
        return penguinsBreedsList[Int.random(in: 0...(penguinsBreedsList.count - 1))]
    }
}
