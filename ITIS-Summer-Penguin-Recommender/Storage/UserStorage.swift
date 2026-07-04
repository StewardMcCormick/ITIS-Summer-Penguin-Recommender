//
//  UserStorage.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Егор Бессонов on 04.07.2026.
//

protocol UserStorage {
    func save(_ user: User)
    
    func getById(_ id: Int64) -> User?
    
    func getByEmail(_ email: String) -> User?
    
    func getAllUsers() -> [User]
}
