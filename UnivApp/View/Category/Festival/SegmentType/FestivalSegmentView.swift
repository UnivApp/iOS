//
//  FestivalSegmentView.swift
//  UnivApp
//
//  Created by 정성윤 on 11/7/24.
//

import SwiftUI
import Kingfisher
import Charts

struct FestivalSegmentView: View {
    var model: [TalentModel]
    var summaryArray: [SummaryModel]
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center, spacing: 30) {
                Image("festivalTitle")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 40)
                
                FestivalChartView(dataPoints: [ChartData(label: model[1].name, value: Double(model[1].count), xLabel: "", yLabel: "", year: ""), ChartData(label: model[0].name, value: Double(model[0].count), xLabel: "", yLabel: "", year: ""), ChartData(label: model[2].name, value: Double(model[2].count), xLabel: "", yLabel: "", year: "")], index: [2, 1, 3])
                    .padding(.top, -30)
                
                Image("festival_poster")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width)
                
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("학교 찾기")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("학교 페이지에서 검색이 가능합니다")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(summaryArray.indices, id: \.self) { index in
                                if (index < 10) && (!summaryArray.isEmpty) {
                                    Button  {
                                        
                                    } label: {
                                        VStack(spacing: 5) {
                                            if let url = summaryArray[index].logo,
                                               let imageURL = URL(string: url),
                                               let name = summaryArray[index].fullName{
                                                KFImage(imageURL)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 30, height: 30)
                                                    .padding(5)
                                                    .background(Circle().fill(.white).shadow(radius: 1))
                                                Text(name)
                                                    .font(.system(size: 10, weight: .semibold))
                                                    .foregroundColor(.black.opacity(0.7))
                                                Spacer()
                                            }
                                        }
                                        .padding(.top, 5)
                                    }
                                    .frame(width: 80, height: 100)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                VStack(spacing: 20) {
                    HStack {
                        Text("랭킹순")
                            .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.primary)
                        Spacer()
                    }
                    ForEach(model.indices, id: \.self) { index in
                        TalentListCellView(model: model[index], index: index+1, size: [50, 50])
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .padding(.top, -20)
            }
        }
    }
}

struct FestivalChartView: View {
    var dataPoints: [ChartData]
    var index: [Int]
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: Date())
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("축제에 가장 많이 출연한 연예인")
                    .font(.system(size: 15, weight: .regular))
                
                Text("TOP3")
                    .font(.system(size: 15, weight: .bold))
                    .overlay(alignment: .bottom) {
                        Color.orange.opacity(0.5)
                            .frame(height: 5)
                    }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            
            HStack {
                Text((dataPoints.compactMap { $0.year }).first ?? "")
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(.gray)
                Spacer()
                Text("\(date) 기준 🗓️")
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, -20)
            
            Chart {
                ForEach(dataPoints.indices, id: \.self) { index in
                    let point = dataPoints[index]
                    BarMark(
                        x: .value(point.xLabel, point.label),
                        y: .value(point.yLabel, point.value)
                    )
                    .opacity(0.9)
                    .foregroundStyle(.orange)
                    .annotation(position: .overlay) {
                        VStack {
                            if self.index[index] == 1 {
                                Text("\(self.index[index])st")
                                    .font(.system(size: 12, weight: .bold))
                            } else if self.index[index] == 2 {
                                Text("\(self.index[index])nd")
                                    .font(.system(size: 12, weight: .bold))
                            } else {
                                Text("\(self.index[index])rd")
                                    .font(.system(size: 12, weight: .bold))
                            }
                            
                            Text(String(format: "%.0f회", point.value))
                                .font(.system(size: 9, weight: .bold))
                        }
                        .foregroundColor(.white)
                    }
                    .annotation(position: .top) {
                            Image("psy")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 30, height: 30)
                                .cornerRadius(15)
                                .padding(.bottom, -10)
                    }
                }
            }
            .chartYAxis{}
            .frame(height: 100)
            .aspectRatio(contentMode: .fit)
            .scaledToFill()
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
        .background(.white)
        .padding(.horizontal, 30)
    }
}

fileprivate struct TalentListCellView: View {
    var model: TalentModel
    var index: Int
    var size: [CGFloat]
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack(alignment: .center, spacing: 30) {
                Text("\(index)")
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundColor(.black.opacity(0.5))
                
                Image("psy")
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: size[0], height: size[1])
                Text(model.name)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black.opacity(0.7))
                Spacer()
                Group {
                    Text("\(model.count)")
                        .foregroundColor(.orange)
                    +
                    Text("회")
                        .foregroundColor(.gray)
                }
                .font(.system(size: 12, weight: .semibold))
            }
            Divider()
        }
        .padding(.horizontal, 10)
    }
}


#Preview {
    FestivalSegmentView(model: [TalentModel(name: "싸이", image: "", count: 300),TalentModel(name: "다비치", image: "", count: 200),TalentModel(name: "다니아믹듀오", image: "", count: 100),TalentModel(name: "싸이", image: "", count: 78)], summaryArray: [SummaryModel(universityId: nil, fullName: nil, logo: nil, starNum: nil, starred: nil)])
}
