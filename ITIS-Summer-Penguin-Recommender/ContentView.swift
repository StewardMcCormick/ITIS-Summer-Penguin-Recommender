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
    private let penguinStorage: PenguinStorage
    
    init() {
        self.quizStorage = JSONQuizStorage(jsonFilename: "quiz")
        self.penguinStorage = JSONPenguinStorage(jsonFilename: "penguins")
    }
    
    var body: some View {
        Group {
            if viewModel.isLoggedIn {
                QuizView(quizStorage: quizStorage,
                         penguineRecommender: PenguinRecommenerServiceImpl(
                            penguinsBreedsList: (try? penguinStorage.getPenguinsData().breeds) ?? []
                         )
                )
            } else {
                LoginView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
