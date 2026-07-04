//
//  UserStorage.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Егор Бессонов on 04.07.2026.
//

import Foundation

protocol UserStorageProtocol {
    
    func save(_ user: User) throws
    
    func getByUsername(_ username: String) -> User?
}
