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
    private let penguinRecommender: PenguinRecommenerService
    
    init() {
        self.quizStorage = JSONQuizStorage(jsonFilename: "quiz")
        self.penguinStorage = JSONPenguinStorage(jsonFilename: "penguins")
        self.penguinRecommender = PenguinRecommenerServiceImpl(
            penguinsBreedsList: (try? penguinStorage.getPenguinsData().breeds) ?? []
        )
    }
    
    var body: some View {
        Group {
            if viewModel.isLoggedIn, let currentUser = viewModel.currentUser {
                QuizView(quizStorage: quizStorage,
                         viewModel: viewModel,
                         penguineRecommender: penguinRecommender,
                         historyStorage: HistoryStorage(userId: currentUser.id)
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
