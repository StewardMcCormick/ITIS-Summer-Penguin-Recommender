//
//  User.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Егор Бессонов on 04.07.2026.
//

import Foundation

struct User: Codable {
    let id: Int64
    var username: String
    var password: String
    
    init(id: Int64 = Int64.random(in: 1...Int64.max), username: String, password: String) {
        self.id = id
        self.username = username
        self.password = password
    }
}
