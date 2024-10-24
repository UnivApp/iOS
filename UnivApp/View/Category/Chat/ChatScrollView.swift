//
//  ChatScrollView.swift
//  UnivApp
//
//  Created by 정성윤 on 10/23/24.
//

import SwiftUI

struct ChatScrollView: View {
    var food: [FoodModel]?
    var news: [NewsModel]?
    var rank: [InitiativeModel]?
    var rent: [MoneyModel]?
    var mou: [MouModel]?
    var hotplace: [PlayDetailModel]?
    var employment: [EmploymentRateResponses]?
    var ontime: [CompetitionRateResponses]?
    var occasion: [CompetitionRateResponses]?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                if let food = food {
                    ChatFoodView(model: food)
                } else if let news = news {
                    
                } else if let rank = rank {
                    
                } else if let rent = rent {
                    
                } else if let mou = mou {
                    
                } else if let hotplace = hotplace {
                    
                } else if let employment = employment {
                    
                } else if let ontime = ontime {
                    
                } else if let occasion = occasion {
                    
                }
            }
            .padding(.horizontal, 40)
        }
        .frame(height: 200)
        .background(.white)
    }
}

fileprivate struct ChatFoodView: View {
    var model: [FoodModel]
    var body: some View {
        ForEach(model.indices, id: \.self) { index in
            VStack(spacing: 10) {
                Text(model[index].name)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 25)
                
                Text(model[index].topMessage ?? "")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.black.opacity(0.7))
                
                HStack(spacing: 5) {
                    ForEach(model[index].hashtags, id: \.self) { hashtag in
                        Text("#\(hashtag) ")
                            .font(.system(size: 12, weight: .semibold))
                    }
                }
                
                Text("📍 \(model[index].location)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.gray)
                
            }
            .padding(10)
            .background(.white)
            .border(.orange, width: 1)
            .overlay(alignment: .topLeading) {
                Text("\(index+1)")
                    .padding(3)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .background(Circle().fill(.orange))
                    .padding(.top, 5)
                    .padding(.leading, 10)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.orange, lineWidth: 2)
            }
            .cornerRadius(15)
        }
        .padding(.vertical, 0)
    }
}

#Preview {
    ChatScrollView(food: [FoodModel(name: "깍뚝", location: "광진구 동일로 459", placeUrl: "ㅋ", hashtags: ["ㅋㅋㅋ", "ㅋㅋㅋ"], topMessage: "광진구 1등 맛집"), FoodModel(name: "깍뚝", location: "광진구 동일로 459", placeUrl: "ㅋ", hashtags: ["ㅋㅋㅋ", "ㅋㅋㅋ"]), FoodModel(name: "깍뚝", location: "광진구 동일로 459", placeUrl: "ㅋ", hashtags: ["ㅋㅋㅋ", "ㅋㅋㅋ"])])
}
