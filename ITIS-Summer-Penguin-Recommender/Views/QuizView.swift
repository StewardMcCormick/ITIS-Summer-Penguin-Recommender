//
//  QuizView.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Элиза Азатовна on 06.07.2026.
//

import SwiftUI

/// Вкладки для навигационной панели
enum QuizTab: String, CaseIterable {
    case quiz = "Анкета"
    case history = "История"
}

struct QuizView: View {
    @Environment(AuthViewModelImpl.self) private var viewModel
    @State private var selectedAnswers: [String: Answer] = [:]
    @State private var selectedTab: QuizTab = .quiz
    @State private var isProfileShows: Bool = false
    private let questions: [Question]

    init(quizStorage: QuizStorage) {
        self.questions = (try? quizStorage.getAllQuestions()) ?? []
    }

    var body: some View {
        VStack(spacing: 0) {
            // Кастомная верхняя панель с двумя табами и кнопкой профиля
            topTabBar

            // Контент в зависимости от выбранного таба
            Group {
                switch selectedTab {
                case .quiz:
                    quizContent
                case .history:
                    historyContent
                }
            }
        }
        .navigationBarHidden(true) // скрываем стандартный navigation bar
        // Раскомментируйте, когда добавите UserProfileView:
        // .sheet(isPresented: $isProfileShows) {
        //     UserProfileView(viewModel: viewModel)
        // }
    }

    // MARK: - Кастомная панель табов
    private var topTabBar: some View {
        HStack(spacing: 0) {
            // Кнопка профиля в левом верхнем углу
            Button(action: {
                isProfileShows = true
            }) {
                Image(systemName: "person.circle")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.black)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1.5)
                    )
            }
            .padding(.leading, 8)
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $isProfileShows) {
                UserProfileView(viewModel: viewModel)
            }

            Spacer()

            ForEach(QuizTab.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 6) {
                        Text(tab.rawValue)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(selectedTab == tab ? .black : .gray)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)

                        // Подчёркивание активного таба
                        Rectangle()
                            .fill(selectedTab == tab ? Color.blue : Color.clear)
                            .frame(height: 3)
                            .cornerRadius(1.5)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(selectedTab == tab ? Color.blue.opacity(0.08) : Color.clear)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }

            // Чтобы кнопка профиля не смещала табы, добавим прозрачный spacer справа
            // (опционально, для симметрии можно сделать равные отступы)
            Spacer()
                .frame(width: 48) // ширина, равная примерной ширине кнопки профиля
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 4)
        .background(Color.white.shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2))
    }

    // MARK: - Контент анкеты
    private var quizContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                // Заголовки анкеты можно оставить или убрать – они уже есть в таб-баре.
                // Для единообразия с историей оставляем их закомментированными:
                // Text("Анкета")
                //     .font(.system(size: 36, weight: .bold))
                //     .underline()
                //     .padding(.top, 10)
                //
                 Text("Отвечай честно! 🤨")
                     .font(.system(size: 30, weight: .bold))
                     .padding(.top, 40)

                ForEach(Array(questions.enumerated()), id: \.element.id) { index, question in
                    QuestionBlock(
                        number: index + 1,
                        question: question.question,
                        answers: question.answers,
                        selectedAnswer: $selectedAnswers[String(question.id)]
                    )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Загрузить фото")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.blue)
                        .padding(.top, 10)

                    Text("*для определения внешнего сходства с пингвином")
                        .font(.system(size: 14))
                        .foregroundColor(.black)

                    Button(action: {}) {
                        Text("Выбрать фото")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.black, lineWidth: 1.5)
                            )
                    }
                    .padding(.top, 5)
                }

                Button(action: {}) {
                    Text("Дай Пингвина!")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(16)
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Контент истории
    private var historyContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                Text("История записей")
                    .font(.system(size: 36, weight: .bold))
                    .padding(.top, 10)

                // TODO: добавить список результатов
                Text("Список предыдущих результатов появится здесь.")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - блок вопроса
struct QuestionBlock: View {
    let number: Int
    let question: String
    let answers: [Answer]
    @Binding var selectedAnswer: Answer?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(number). \(question)")
                .font(.system(size: 20, weight: .bold))
                .padding(.top, 10)

            ForEach(answers, id: \.id) { answer in
                Button(action: {
                    selectedAnswer = answer
                }) {
                    Text(answer.label)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedAnswer?.id == answer.id ? Color.blue.opacity(0.2) : Color.clear)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black, lineWidth: 1.5)
                        )
                }
            }
        }
    }
}

// MARK: - Отдельная HistoryView (оставлена для совместимости, не используется в QuizView)
struct HistoryView: View {
    var body: some View {
        Text("История записей")
            .font(.title)
            .navigationTitle("История")
    }
}

#Preview {
    QuizView(quizStorage: JSONQuizStorage(jsonFilename: "quiz"))
        .environment(AuthViewModelImpl())
}
