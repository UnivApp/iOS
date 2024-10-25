//
//  ChatScrollView.swift
//  UnivApp
//
//  Created by 정성윤 on 10/23/24.
//

import SwiftUI
import Kingfisher

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
                    ChatNewsView(model: news)
                } else if let rank = rank {
                    ChatRankView(model: rank)
                } else if let rent = rent {
                    
                } else if let mou = mou {
                    ChatMouView(model: mou)
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

fileprivate struct ChatMouView: View {
    var model: [MouModel]
    var body: some View {
        ForEach(model.indices, id: \.self) { index in
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(model[index].category)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Group {
                        if model[index].status == "접수 중" {
                            Text(model[index].status)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.orange).frame(width: 80, height: 30))
                        } else {
                            Text(model[index].status)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.gray).frame(width: 80, height: 30))
                        }
                    }
                    .padding(.trailing, 20)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundColor(.white)
                }
                
                Text(model[index].title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack {
                    Text(model[index].date)
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.trailing)
                    Spacer()
                    Text("\(model[index].expoYear) 대입")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                }
            }
            .padding(30)
            .background(.white)
            .cornerRadius(15)
            .shadow(color: .orange, radius: 2)
        }
        .padding(.vertical, 10)
    }
}

fileprivate struct ChatRankView: View {
    var model: [InitiativeModel]
    var body: some View {
        
        VStack(alignment: .center) {
            HStack {
                Text("QS 세계대학평가")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
            }
            ForEach(model.indices, id: \.self) { index in
                if index < 5 {
                    HStack(spacing: 10) {
                        if let rankingResponses = model[index].universityRankingResponses.first {
                            Text("\(rankingResponses.rank)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(Color.white)
                                .padding(5)
                                .background(Circle().fill(.orange))
                                .multilineTextAlignment(.center)
                            
                            Group {
                                if let image = rankingResponses.logo {
                                    KFImage(URL(string: image))
                                        .resizable()
                                        .scaledToFit()
                                } else {
                                    Image("no_image")
                                        .resizable()
                                        .scaledToFit()
                                }
                            }
                            .frame(width: 20, height: 20)
                            
                            Text(rankingResponses.universityName)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color.black)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 30)
                }
            }
            .padding(.vertical, 0)
        }
        .padding(10)
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(.orange, lineWidth: 2)
        }
        .cornerRadius(15)
    }
}

fileprivate struct ChatNewsView: View {
    var model: [NewsModel]
    var body: some View {
        ForEach(model.indices, id: \.self) { index in
            if index < 10 {
                ZStack {
                    Image("info")
                        .resizable()
                        .scaledToFill()
                        .opacity(0.1)
                    
                    Button  {
                        if let url = URL(string: model[index].link ?? "" ){
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        VStack(spacing: 10) {
                            Text(model[index].title)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.top, 25)
                            
                            HStack {
                                Spacer()
                                Text(model[index].admissionYear)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(.black.opacity(0.7))
                            }
                            
                            Text(model[index].source ?? "")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.black.opacity(0.7))
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .frame(width: 200, height: 200)
                .padding(.horizontal, 20)
            }
        }
        .padding(.vertical, 0)
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
    ChatScrollView(mou: [MouModel(expoId: 0, title: "헬로헬로방구방구", category: "취업진로", expoYear: "2023.12.12 ~ 2023.12.12", status: "접수 중", location: "서울시 광진구 동일로", content: "s", date: "2023.12.12")])
}
