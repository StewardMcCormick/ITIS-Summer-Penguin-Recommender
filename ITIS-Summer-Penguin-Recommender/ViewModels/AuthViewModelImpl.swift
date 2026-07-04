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
    
    //вход в систему
    func login(email: String, password: String) -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Заполните все поля"
            return false
        }
        
        guard let user = storage.getByEmail(email) else {
            errorMessage = "Пользователь не найден"
            return false
        }
        
        guard user.password == password else {
            errorMessage = "Неверный пароль"
            return false
        }
        
        currentUser = user
        isLoggedIn = true
        saveCurrentUser()
        errorMessage = nil
        return true
    }
    
    //регистрация
    func register(username: String, email: String, password: String) -> Bool {
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "Заполните все поля"
            return false
        }
        
        if storage.getByEmail(email) != nil {
            errorMessage = "Пользователь с таким email уже существует"
            return false
        }
        
        let newUser = User(username: username, email: email, password: password)
        storage.save(newUser)
        
        errorMessage = nil
        return true
    }
    
    //выход
    func logout() {
        currentUser = nil
        isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: currentUserKey)
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
