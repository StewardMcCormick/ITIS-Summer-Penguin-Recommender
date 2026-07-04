//
//  LoginView.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Элиза Азатовна on 05.07.2026.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isRegistering = false
    @State private var username = ""
    var viewModel: AuthViewModel 
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                Text("Выбери своего пингвина! 🐧")
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 60)
                
                VStack(spacing: 20) {
                    Text(isRegistering ? "Регистрация" : "Вход")
                        .font(.system(size: 28, weight: .semibold))
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    if isRegistering {
                        TextField("Имя пользователя", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    SecureField("Пароль", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button(action: handleSubmit) {
                        Text(isRegistering ? "Зарегистрироваться" : "Войти")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    
                    Button(action: {
                        isRegistering.toggle()
                    }) {
                        Text(isRegistering ? "Уже есть аккаунт? Войти" : "Нет аккаунта?\nЗарегистрироваться")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal, 30)
                .padding(.top, 40)
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
    
    private func handleSubmit() {
        if isRegistering {
            if viewModel.register(username: username, email: email, password: password) {
                isRegistering = false
            }
        } else {
            _ = viewModel.login(email: email, password: password)
        }
    }
}

#Preview {
    LoginView(viewModel: AuthViewModelImpl())
}
