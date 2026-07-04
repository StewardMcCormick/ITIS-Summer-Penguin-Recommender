//
//  ContentView.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Егор Бессонов on 04.07.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LoginView(viewModel: AuthViewModelImpl())
    }
}

#Preview {
    ContentView()
}
