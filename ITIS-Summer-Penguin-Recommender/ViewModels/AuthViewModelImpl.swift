//
//  AuthViewModelImpl.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Элиза Азатовна on 05.07.2026.
//

import Foundation
import Observation

@Observable
class AuthViewModelImpl: AuthViewModel {
    private let storage: UserStorage
    private let currentUserKey = "currentUser"
    
    var currentUser: User?
    var isLoggedIn: Bool = false
    var errorMessage: String?
    
    init(storage: UserStorage = UserStorageImpl()) {
        self.storage = storage
        checkCurrentUser()
    }
    
    func login(username: String, password: String) {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Заполните все поля"
            return
        }
        
        guard let user = storage.getByUsername(username) else {
            errorMessage = "Пользователь не найден"
            return
        }
        
        guard user.password == password else {
            errorMessage = "Неверный пароль"
            return
        }
        
        currentUser = user
        isLoggedIn = true
        saveCurrentUser()
        errorMessage = nil
    }
    
    func register(username: String, password: String, repeatedPassword: String) -> Bool {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Заполните все поля"
            return false
        }
        
        guard password == repeatedPassword else {
            errorMessage = "Пароли не соответствуют"
            return false
        }
        
        if storage.getByUsername(username) != nil {
            errorMessage = "Пользователь с таким именем уже существует"
            return false
        }
        
        let newUser = User(username: username, password: password)
        storage.save(newUser)
        
        errorMessage = nil
        return true
    }
    
    func logout() {
        currentUser = nil
        isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: currentUserKey)
    }
    
    func updateUser(oldUsername: String, newUsername: String, newPassword: String) {
        do {
            try storage.updateUser(oldUsername: oldUsername, newUsername: newUsername, newPassword: newPassword)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    //проверка авторизации
    private func checkCurrentUser() {
        guard let data = UserDefaults.standard.data(forKey: currentUserKey),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return
        }
        currentUser = user
        isLoggedIn = true
    }
    
    private func saveCurrentUser() {
        if let user = currentUser,
           let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: currentUserKey)
        }
    }
}
