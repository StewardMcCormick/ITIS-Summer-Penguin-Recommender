//
//  RecommendedPenguinView.swift
//  ITIS-Summer-Penguin-Recommender
//
//  Created by Егор Бессонов on 08.07.2026.
//

import SwiftUI

struct RecommendedPenguinView: View {
    
    @Environment(\.dismiss) private var dismiss
    var currentBreed: Breed?
    
    var body: some View {
        
        VStack(spacing: 8) {
            if let currentBreed = currentBreed {
                SuccesRecommendation(currentPenguin: currentBreed)
            } else {
                NoOnePenguinRecommended()
            }
            
            Button(action: {
                dismiss()
            }) {
                Text("Попробовать еще раз")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(16)
                    .padding([.trailing, .leading])
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        
    }
}

struct SuccesRecommendation: View {
    
    let currentPenguin: Breed
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Ваш пингвин - \(currentPenguin.name)🎉!")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Image(currentPenguin.userInfo.imageUrl)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 16)
                
                PenguinInformationView(infoRows: [
                    InfoRow(title: "По-научному🧐: ", value: currentPenguin.userInfo.scientificName),
                    InfoRow(title: "Размер📏: ", value: currentPenguin.userInfo.size),
                    InfoRow(title: "Средний рост🐧: ", value: "\(currentPenguin.userInfo.heightCm) см"),
                    InfoRow(title: "Средний вес🏋️‍♂️: ", value: String(format: "%.2f кг", currentPenguin.userInfo.weightKg)),
                    InfoRow(title: "Продолжительность жизни⏳: ", value: getLifespanString(years: currentPenguin.userInfo.lifespanYears)),
                    InfoRow(title: "Короткое описание📕: ", value: currentPenguin.userInfo.description),
                    InfoRow(title: "Важные моменты❗️: ", value: currentPenguin.userInfo.careTips),
                    InfoRow(title: "Питание🐟: ", value: currentPenguin.userInfo.diet),
                    InfoRow(title: "Интересный факт🤓: ", value: currentPenguin.userInfo.funFact),
                ])
            }
        }
    }
}

func getLifespanString(years: Int) -> String {
    let lastDigit = years % 10
    let lastTwoDigits = years % 100
    var word = ""
    
    if lastTwoDigits >= 11 && lastTwoDigits <= 14 {
        word = "лет"
    } else {
        switch lastDigit {
        case 1:
            word = "год"
        case 2, 3, 4:
            word = "года"
        default:
            word = "лет"
        }
    }
    
    return "\(years) \(word)"
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .foregroundColor(.gray)
                .underline()
                .frame(width: 200, alignment: .leading)
            Text(value)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
        .padding(4)
        Divider().padding(.vertical, 6)
    }
}

struct PenguinInformationView: View {
    var infoRows: [InfoRow]
    
    var body: some View {
        ForEach(infoRows.indices, id: \.self) { idx in
            infoRows[idx]
        }
        .padding(.horizontal, 16)
    }
}

struct NoOnePenguinRecommended: View {
    
    let comfortMessage = "К сожалению, мы не нашли пингвина для Вас. Возможно, когда-нибудь обстоятельства изменятся, мы с радостью поможем Вам найти идеального друга!"
    
    var body: some View {
        
        VStack {
            Text("Не смогли подобрать Вам пингвина😔")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
            
            Image("sad-penguin")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 16)
                        
            Text(comfortMessage)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding()
            
        }
    }
}

#Preview {
    RecommendedPenguinView(
        currentBreed: (try? JSONPenguinStorage(
            jsonFilename: "penguins")
        .getPenguinsData()
        .breeds.first) ?? nil
    )
}

//#Preview {
//    RecommendedPenguinView(currentBreed: (nil))
//}
