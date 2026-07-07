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
        
        updateUserDefaults(users)
    }
    
    func getById(_ id: UUID) -> User? {
        return getAllUsers().first { $0.id == id }
    }
    
    func getByUsername(_ username: String) -> User? {
        return getAllUsers().first { $0.username.lowercased() == username.lowercased() }
    }
    
    func getAllUsers() -> [User] {
        guard let data = UserDefaults.standard.data(forKey: usersKey),
              let users = try? JSONDecoder().decode([User].self, from: data) else {
            return []
        }
        return users
    }
    
    func updateUser(
        oldUsername: String,
        newUsername: String,
        newPassword: String
    ) throws {
        var users = getAllUsers()
        
        guard let index = users.firstIndex(where: {
            $0.username.lowercased() == oldUsername.lowercased()
        }) else {
            throw UserStorageError.userNotFound(username: newUsername)
        }
        
        let isNewUsernameTaken = users.contains { user in
            user.username.lowercased() == newUsername.lowercased() &&
            user.username.lowercased() != oldUsername.lowercased()
        }
        
        guard !isNewUsernameTaken else {
            throw UserStorageError.usernameAlreadyTaken(username: newUsername)
        }
        
        var updatedUser = users[index]
        updatedUser.username = newUsername
        if newPassword != "" {
            updatedUser.password = newPassword
        }
        users[index] = updatedUser
        
        updateUserDefaults(users)
    }
    
    private func updateUserDefaults(_ users: [User]) {
        if let data = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(data, forKey: usersKey)
        }
    }
}
