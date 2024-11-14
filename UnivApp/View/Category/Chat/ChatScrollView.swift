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
    var rent: [String]?
    var mou: [MouModel]?
    var hotplace: [PlayModel]?
    var employment: [EmploymentModel]?
    var ontime: [CompetitionModel]?
    var occasion: [CompetitionModel]?
    
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
                    ChatRentView(averageRent: rent)
                } else if let mou = mou {
                    ChatMouView(model: mou)
                } else if let hotplace = hotplace {
                    ChatPlayView(playViewModel: PlayViewModel(container: .init(services: Services())), model: hotplace)
                } else if let employment = employment {
                    ChatRateView(employModel: employment, modelType: "취업률")
                } else if let ontime = ontime {
                    ChatRateView(competitionModel: ontime, modelType: "정시 경쟁률")
                } else if let occasion = occasion {
                    ChatRateView(competitionModel: occasion, modelType: "수시 경쟁률")
                }
            }
            .padding(.horizontal, 40)
        }
        .frame(height: 200)
        .background(.white)
    }
}

fileprivate struct ChatRentView: View {
    var averageRent: [String]
    var body: some View {
        VStack {
            ZStack {
                VStack(spacing: 10) {
                    Text("\(averageRent[0])/\(averageRent[1])")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.orange)
                    Text("평균 평수 : \(averageRent[2])㎡")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.blue.opacity(0.5))
                    Group {
                        if averageRent.count == 4 {
                            Text("\(averageRent[3]) 지역 월세 평균 호가 🔍")
                        } else {
                            Text("서울 지역 월세 평균 호가 🔍")
                        }
                    }
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black.opacity(0.7))
                }
                HStack(alignment: .center) {
                    Spacer()
                    LoadingView(url: "coinGif", size: [80,200])
                        .opacity(0.7)
                }
            }
            
            HStack {
                Spacer()
                Text("정보제공 : 서울 열린데이터 광장")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 5)
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(.orange, lineWidth: 2)
        }
        .cornerRadius(15)
    }
}


fileprivate struct ChatPlayView: View {
    @StateObject var playViewModel: PlayViewModel
    
    var model: [PlayModel]
    var body: some View {
        ForEach(model.indices, id: \.self) { index in
            representativePlaceCell(playDetailModel: PlayDetailModel(object: playViewModel.convertToObjects(from: model), placeDataArray: model, placeData: model[index]))
        }
        .frame(height: 220)
        .cornerRadius(15)
    }
}

fileprivate struct ChatRateView: View {
    var employModel: [EmploymentModel]?
    var competitionModel: [CompetitionModel]?
    var modelType: String
    
    @State var chartData: [[ChartData]] = []
    @State private var phase: Phase = .notRequested
    var body: some View {
        contentView
    }
    @ViewBuilder
    var contentView: some View {
        switch self.phase {
        case .notRequested:
            PlaceholderView().onAppear { self.setChartData() }
        case .loading:
            LoadingView(url: "load", size: [100, 100])
        case .success:
            loadedView
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        ForEach(chartData.indices, id: \.self) { index in
            BarChartView(title: modelType, description: "대학어디가 - 정보제공", dataPoints: chartData[index])
                .frame(width: 200)
        }
    }
    
    private func setChartData() {
        var sectionChartData: [ChartData] = []
        self.phase = .loading
        if let eModel = employModel,
        let rate = eModel.compactMap({ $0.employmentRateResponses }).first {
            let value = rate.compactMap { $0.employmentRate }
            let year = rate.compactMap { $0.year }
            
            for index in value.indices {
                sectionChartData.append(ChartData(label: year[index], value: value[index], xLabel: "년도", yLabel: "비율", year: year[index]))
            }
        } else if let cModel = competitionModel,
                  let rate = cModel.compactMap({ $0.competitionRateResponses }).first {
            let earlyValue = rate.compactMap { $0.earlyAdmissionRate }
            let regularValue = rate.compactMap { $0.regularAdmissionRate }
            let year = rate.compactMap { $0.year }
            if modelType == "수시 경쟁률" {
                for index in earlyValue.indices {
                    sectionChartData.append(ChartData(label: year[index], value: earlyValue[index], xLabel: "년도", yLabel: "비율", year: year[index]))
                }
            } else {
                for index in regularValue.indices {
                    sectionChartData.append(ChartData(label: year[index], value: regularValue[index], xLabel: "년도", yLabel: "비율", year: year[index]))
                }
            }
        }
        self.chartData.append(sectionChartData)
        self.phase = .success
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
                
                Text(model[index].addressName)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.black.opacity(0.7))
                
                Text("📍 \(model[index].roadAddressName)")
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
    ChatScrollView(rent: ["123","123","123"])
}
