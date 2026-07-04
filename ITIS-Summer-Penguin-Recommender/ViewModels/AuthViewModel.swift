//
//  AuthViewModel.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Егор Бессонов on 04.07.2026.
//

import Foundation

protocol AuthViewModelProtocol {
    
    func register(_ user: User) throws
    
    func login(_ user: User) throws
    
    func logout()
}
