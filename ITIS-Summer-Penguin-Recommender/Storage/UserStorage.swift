//
//  UserStorage.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Егор Бессонов on 04.07.2026.
//

import Foundation

protocol UserStorage {
    func save(_ user: User)
    
    func getById(_ id: UUID) -> User?
    
    func getByUsername(_ username: String) -> User?
    
    func getAllUsers() -> [User]
}
