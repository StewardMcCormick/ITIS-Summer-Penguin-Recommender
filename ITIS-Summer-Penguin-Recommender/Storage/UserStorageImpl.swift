//
//  UserStorageImpl.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Элиза Азатовна on 05.07.2026.
//

import Foundation

class UserStorageImpl: UserStorage {
    private let usersKey = "registeredUsers"
    
    func save(_ user: User) {
        var users = getAllUsers()
        users.append(user)
        
        if let data = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(data, forKey: usersKey)
        }
    }
    
    func getById(_ id: Int64) -> User? {
        return getAllUsers().first { $0.id == id }
    }
    
    func getByEmail(_ email: String) -> User? {
        return getAllUsers().first { $0.email.lowercased() == email.lowercased() }
    }
    
    func getAllUsers() -> [User] {
        guard let data = UserDefaults.standard.data(forKey: usersKey),
              let users = try? JSONDecoder().decode([User].self, from: data) else {
            return []
        }
        return users
    }
}
