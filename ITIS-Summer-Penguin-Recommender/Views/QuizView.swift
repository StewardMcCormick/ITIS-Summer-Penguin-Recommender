//
//  QuizView.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Элиза Азатовна on 06.07.2026.
//

import SwiftUI

struct QuizView: View {
    @State private var selectedAnswers: [String: Answer] = [:]
    private let questions: [Question]
    
    init(quizStorage: QuizStorage) {
        self.questions = (try? quizStorage.getAllQuestions()) ?? []
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    HStack {
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Button(action: {}) {
                                Image(systemName: "line.3.horizontal")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(.black)
                                    .padding(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.black, lineWidth: 1.5)
                                    )
                            }
                            NavigationLink(destination: HistoryView()) {
                                Text("История")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.blue)
                                    .underline()
                            }
                        }
                    }
                    .padding(.top, 10)
                
                    Text("Анкета")
                        .font(.system(size: 36, weight: .bold))
                        .underline()
                        .padding(.top, 10)

                    Text("Отвечай честно! 🤨")
                        .font(.system(size: 22, weight: .bold))
                        .padding(.bottom, 10)
                    
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
                            HStack {
                                Text("Выбрать фото")
                            }
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
            .navigationBarHidden(true)
        }
    }
}

// MARK: блок вопроса
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
                                .stroke(Color.black, lineWidth: 1.5)
                                .fill(selectedAnswer?.id == answer.id ? Color.blue.opacity(0.2) : Color.clear)
                        )
                }
            }
        }
    }
}

// MARK: временная версия экрана истории
struct HistoryView: View {
    var body: some View {
        Text("История записей")
            .font(.title)
            .navigationTitle("История")
    }
}

#Preview {
    QuizView(quizStorage: JSONQuizStorage(jsonFilename: "quiz"))
}
