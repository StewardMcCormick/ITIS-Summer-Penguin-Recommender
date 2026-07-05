//
//  AuthViewModel.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Егор Бессонов on 04.07.2026.
//

import Foundation

protocol AuthViewModel {
    var currentUser: User? { get set }
    var isLoggedIn: Bool { get set }
    var errorMessage: String? { get set }
    
    func login(username: String, password: String) -> Bool
    func register(username: String, password: String, repeatedPassword: String) -> Bool
    func logout()
}
