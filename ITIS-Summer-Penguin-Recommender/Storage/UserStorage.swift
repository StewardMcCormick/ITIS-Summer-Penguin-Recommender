//
//  UserStorage.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Егор Бессонов on 04.07.2026.
//

import Foundation

enum UserStorageError: LocalizedError {
    case userNotFound(username: String)
    case usernameAlreadyTaken(username: String)
    
    var errorDescription: String? {
        switch self {
        case .userNotFound(let username):
            return "Пользователь '\(username)' не найден"
        case .usernameAlreadyTaken(let username):
            return "Имя пользователя '\(username)' уже занято"
        }
    }
}

protocol UserStorage {
    func save(_ user: User)
    
    func getById(_ id: UUID) -> User?
    
    func getByUsername(_ username: String) -> User?
    
    func getAllUsers() -> [User]
    
    func updateUser(oldUsername: String, newUsername: String, newPassword: String) throws
}
