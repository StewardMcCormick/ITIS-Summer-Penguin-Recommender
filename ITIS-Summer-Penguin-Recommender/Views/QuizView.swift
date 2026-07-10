//
//  QuizView.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Элиза Азатовна on 06.07.2026.
//

import SwiftUI
import PhotosUI
import UIKit

enum QuizTab: String, CaseIterable {
    case quiz = "Анкета"
    case history = "История"
}

struct QuizView: View {
    @State private var selectedAnswers: [String: QuizAnswer] = [:]
    @State private var historyRecords: [HistoryRecord] = []
    @State private var searchText = ""
    
    private var penguinRecommender: PenguinRecommenerService
    private let historyStorage: HistoryStorage
    
    private var viewModel: AuthViewModel
    @State private var selectedTab: QuizTab = .quiz
    @State private var isProfileShows: Bool = false
    @State private var recommendedBreed: Breed? = nil
    private let questions: [Question]
    
    // Фото, выбранное пользователем
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedPhoto: Data? = nil
    
    private var isAllQuestionsAnswered: Bool {
        !questions.isEmpty && questions.count == selectedAnswers.count
    }
        
    private var filteredRecords: [HistoryRecord] {
        if searchText.isEmpty {
            return historyRecords
        } else {
            return historyRecords.filter {
                $0.recordTitle.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    init(quizStorage: QuizStorage, viewModel: AuthViewModel, penguineRecommender: PenguinRecommenerService, historyStorage: HistoryStorage) {
        self.questions = (try? quizStorage.getAllQuestions()) ?? []
        self.viewModel = viewModel
        self.penguinRecommender = penguineRecommender
        self.historyStorage = historyStorage
        self._historyRecords = State(initialValue: historyStorage.getAllRecords())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            topTabBar
            Group {
                switch selectedTab {
                case .quiz:
                    quizContent
                case .history:
                    historyContent
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $isProfileShows) {
            UserProfileView(viewModel: viewModel)
        }
        .sheet(item: $recommendedBreed) { breed in
            RecommendedPenguinView(currentBreed: breed)
        }
    }
    
    // MARK: - Кастомная панель табов
    private var topTabBar: some View {
        HStack(spacing: 0) {
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
            
            Spacer()
                .frame(width: 48)
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
                Text("Отвечай честно! 🤨")
                    .font(.system(size: 30, weight: .bold))
                    .padding(.top, 40)
                
                ForEach(Array(questions.enumerated()), id: \.element.id) { index, question in
                    QuestionBlock(
                        number: index + 1,
                        question: question.question,
                        answers: question.answers.map { answer in
                            QuizAnswer(
                                id: answer.id,
                                label: answer.label,
                                value: answer.value,
                                weight: answer.weight
                            )
                        },
                        selectedAnswer: $selectedAnswers[String(question.id)]
                    )
                }
                
                photoSelectionBlock
                
                Button(action: {
                    let sortedAnswers = questions.compactMap { question in
                        selectedAnswers[String(question.id)]
                    }
                    
                    let breed = penguinRecommender.recommenedPenguin(
                        answers: sortedAnswers
                    )
                    
                    let record: HistoryRecord
                    if let breed = breed {
                        record = HistoryRecord(
                            isPenguinRecommended: true,
                            breedId: breed.id,
                            recordTitle: breed.name,
                            userAnswers: Dictionary(uniqueKeysWithValues:
                                selectedAnswers.map { ($0.key, $0.value.value) }
                            )
                        )
                    } else {
                        record = HistoryRecord(
                            isPenguinRecommended: false,
                            breedId: nil,
                            recordTitle: "Подобрать пингвина не удалось",
                            userAnswers: Dictionary(uniqueKeysWithValues: selectedAnswers.map { ($0.key, $0.value.value) })
                        )
                    }
                    
                    historyStorage.save(record: record)
                    historyRecords = historyStorage.getAllRecords()
                    
                    recommendedBreed = breed
                }) {
                    Text("Дай Пингвина!")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isAllQuestionsAnswered ? Color.blue : Color.gray)
                        .cornerRadius(16)
                }
                .disabled(!isAllQuestionsAnswered)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Блок выбора фото
    private var photoSelectionBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Text("Загрузить фото")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.blue)
                if selectedPhoto != nil {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green.opacity(0.8))
                        .font(.system(size: 18))
                }
            }
            .padding(.top, 10)
            
            Text("*для определения внешнего сходства с пингвином, но это необязательно😉")
                .font(.system(size: 14))
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Text(selectedPhoto != nil ? "Изменить фото" : "Выбрать фото")
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 1.5)
                    )
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let photo = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedPhoto = photo
                        penguinRecommender.setUserPhoto(photo: photo)
                    } else {
                        selectedPhoto = nil
                    }
                }
            }
            .padding(.top, 5)
            
            if selectedPhoto != nil {
                Button {
                    selectedItem = nil
                    selectedPhoto = nil
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "xmark.circle")
                        Text("Отменить выбор")
                    }
                    .font(.system(size: 15))
                    .foregroundColor(.red)
                    .padding(.vertical, 8)
                }
            }
        }
    }
    
    // MARK: - Контент истории
    private var historyContent: some View {
        NavigationStack {
            List {
                if filteredRecords.isEmpty && !searchText.isEmpty {
                    Text("Ничего не найдено")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                    
                } else if filteredRecords.isEmpty {
                    Text("История пуста")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                                        
                } else {
                    ForEach(filteredRecords) { record in
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(record.recordTitle)
                                    .font(.headline)
                                Text(record.date.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: deleteHistoryRecord)
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText, prompt: "Поиск")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func deleteHistoryRecord(at offsets: IndexSet) {
        for index in offsets {
            let record = filteredRecords[index]
            historyStorage.deleteRecord(id: record.id)
        }
        historyRecords = historyStorage.getAllRecords()
    }
}

// MARK: - блок вопроса
struct QuestionBlock: View {
    let number: Int
    let question: String
    let answers: [QuizAnswer]
    @Binding var selectedAnswer: QuizAnswer?
    
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

#Preview {
    QuizView(
        quizStorage: JSONQuizStorage(jsonFilename: "quiz"),
        viewModel: AuthViewModelImpl(),
        penguineRecommender: PenguinRecommenerServiceImpl(
            userPhotoAnalizeService: RandomUserPhotoAnalizeService(penguinsBreedsList: []),
            penguinsBreedsList: []
        ),
        historyStorage: HistoryStorage(userId: UUID())
    )
}
