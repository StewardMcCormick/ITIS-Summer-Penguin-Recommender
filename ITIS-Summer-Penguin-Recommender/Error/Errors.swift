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
        case .alreadyExist: return "user already exist"
        }
    }
}
