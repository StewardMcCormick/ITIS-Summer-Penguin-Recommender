//
//  ContentView.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Егор Бессонов on 04.07.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = AuthViewModelImpl()
    private let quizStorage: QuizStorage
    
    init() {
        
        self.quizStorage = JSONQuizStorage(jsonFilename: "quiz")
    }
    
    var body: some View {
        Group {
            if viewModel.isLoggedIn {
                QuizView(quizStorage: quizStorage)
            } else {
                LoginView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
