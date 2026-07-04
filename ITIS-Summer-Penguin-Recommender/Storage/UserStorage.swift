//
//  UserStorage.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Егор Бессонов on 04.07.2026.
//

import Foundation

protocol UserStorage {
    
    func save(_ user: User) -> User?
    
    func getById(_ id: Int64) -> User?
}
