//
//  FestivalSegmentView.swift
//  UnivApp
//
//  Created by 정성윤 on 11/7/24.
//

import SwiftUI
import Kingfisher
struct FestivalSegmentView: View {
    var model: [TalentModel]
    var summaryArray: [SummaryModel]
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: Date())
    }
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center, spacing: 30) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("대학 축제 출연 ")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                        +
                        Text("랭킹")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.orange)
                        Text("\(date) 기준 🗓️")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 20) {
                        TalentCellView(model: model[0], index: 1)
                        HStack {
                            TalentCellView(model: model[1], index: 2)
                            Spacer()
                            TalentCellView(model: model[1], index: 3)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
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

fileprivate struct TalentCellView: View {
    var model: TalentModel
    var index: Int
    var body: some View {
        HStack(alignment: .center, spacing: 30) {
            Spacer()
            ZStack {
                LoadingView(url: "firework-unscreen", size: [150, 150])
                    .padding(.leading, -40)
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(index)")
                        .font(.system(size: 50, weight: .heavy))
                        .foregroundColor(.orange)
                    Text(model.name)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.primary)
                    Text("\(model.count)회")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.gray)
                }
            }
            VStack {
                //TODO: - KFImage로 변경
                Image("psy")
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
                Group {
                    if index == 1 {
                        Text("🥇")
                    } else if index == 2 {
                        Text("🥈")
                    } else if index == 3 {
                        Text("🥉")
                    }
                }
                .font(.system(size: 40, weight: .heavy))
                .padding(.top, -20)
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 60, height: (UIScreen.main.bounds.width - 60) / 1.6)
        .background(RoundedRectangle(cornerRadius: 15).fill(.white).stroke(.orange.opacity(0.7), lineWidth: 20))
        .cornerRadius(15)
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
    FestivalSegmentView(model: [TalentModel(name: "싸이", image: "", count: 1231),TalentModel(name: "싸이", image: "", count: 1231),TalentModel(name: "싸이", image: "", count: 1231),TalentModel(name: "싸이", image: "", count: 1231)], summaryArray: [SummaryModel(universityId: nil, fullName: nil, logo: nil, starNum: nil, starred: nil)])
}
