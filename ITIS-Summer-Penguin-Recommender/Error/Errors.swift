//
//  errors.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Егор Бессонов on 04.07.2026.
//

import Foundation

protocol AppError: Error {
    var message: String { get }
}

enum UserStorageError: AppError {
    case alreadyExist
    
    var message: String {
        switch self {
        case .alreadyExist: return "Пользователь с таким именем уже существует"
        }
    }
}

enum AuthenticationError: AppError {
    case incorrectCredentials
    
    var message: String {
        switch self {
        case .incorrectCredentials: return "Неправильное имя или пароль"
        }
    }
}
