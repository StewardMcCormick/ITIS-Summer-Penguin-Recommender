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
    private let historyStorage: HistoryStorage
    
    init() {
        self.quizStorage = JSONQuizStorage(jsonFilename: "quiz")
        self.penguinStorage = JSONPenguinStorage(jsonFilename: "penguins")
        self.historyStorage = HistoryStorage()
        self.penguinRecommender = PenguinRecommenerServiceImpl(
            penguinsBreedsList: (try? penguinStorage.getPenguinsData().breeds) ?? []
        )
    }
    
    var body: some View {
        Group {
            if viewModel.isLoggedIn {
                QuizView(quizStorage: quizStorage,
                         viewModel: viewModel,
                         penguineRecommender: penguinRecommender,
                         historyStorage: historyStorage
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
