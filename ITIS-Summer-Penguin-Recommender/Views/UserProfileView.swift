//
//  UserProfileView.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Егор Бессонов на 06.07.2026.
//

import SwiftUI

struct UserProfileView: View {
    
    var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        
        
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: geometry.size.height * 0.04) {
                    
                    Text("Ваш профиль")
                        .font(.system(size: 36, weight: .bold))
                        .padding(.top, 10)
                    
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray.opacity(0.8))
                    
                    VStack(spacing: geometry.size.height * 0.03) {
                        TextField("Имя пользователя", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray, lineWidth: 1.5)
                            )
                        
                        SecureField("Пароль", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray, lineWidth: 1.5)
                            )
                    }
                    .padding(.horizontal, geometry.size.width * 0.08)
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button(action: saveChanges) {
                        Text("Сохранить")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue.opacity(0.9))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    .padding(.horizontal, geometry.size.width * 0.08)
                    
                    Button(action: viewModel.logout) {
                        Text("Выйти")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.red.opacity(0.75))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    .padding(.horizontal, geometry.size.width * 0.08)
                    
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
            }
            .onAppear {
                if let user = viewModel.currentUser {
                    username = user.username
                    password = user.password
                }
            }
        }
    }
    
    private func saveChanges() {
        if let user = viewModel.currentUser {
            viewModel.updateUser(oldUsername: user.username, newUsername: username, newPassword: password)
        }
    }
}

#Preview {
    UserProfileView(viewModel: AuthViewModelImpl())
}
