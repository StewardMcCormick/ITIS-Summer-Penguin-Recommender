//
//  User.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Егор Бессонов on 04.07.2026.
//

import Foundation

struct User: Codable {
    let id: UUID
    var username: String
    var password: String
    
    init(id: UUID = UUID(), username: String, password: String) {
        self.id = id
        self.username = username
        self.password = password
    }
}
