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
                    LoadingView(url: "firework", size: [100, 100])
                }
                .padding(.vertical, -20)
                .padding(.horizontal, 20)
                
                VStack(alignment: .center, spacing: 10) {
                    TalentCellView(model: model[0], index: 1, size: [100, 100])
                    HStack {
                        TalentCellView(model: model[1], index: 2, size: [70, 70])
                        Spacer()
                        TalentCellView(model: model[1], index: 3, size: [70, 70])
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, -100)
                }
                .padding(.horizontal, 20)
                
                SeperateView()
                    .frame(width: UIScreen.main.bounds.width, height: 20)
                
                VStack(spacing: 20) {
                    HStack {
                        Text("랭킹순")
                            .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.black)
                        Spacer()
                    }
                    ForEach(model.indices, id: \.self) { index in
                        TalentListCellView(model: model[index], index: index+1, size: [50, 50])
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
    }
}

fileprivate struct TalentCellView: View {
    var model: TalentModel
    var index: Int
    var size: [CGFloat]
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            //TODO: - KFImage로 변경
            Image("psy")
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: size[0], height: size[1])
                
            Group {
                if index == 1 {
                    Text("🥇")
                } else if index == 2 {
                    Text("🥈")
                } else if index == 3 {
                    Text("🥉")
                }
            }
            .font(.system(size: 30, weight: .heavy))
            .padding(.top, -20)
            
            Text(model.name)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.black.opacity(0.7))
            Text("\(model.count)회")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.gray)
            
        }
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
    FestivalSegmentView(model: [TalentModel(name: "싸이", image: "", count: 1231),TalentModel(name: "싸이", image: "", count: 1231),TalentModel(name: "싸이", image: "", count: 1231),TalentModel(name: "싸이", image: "", count: 1231)])
}
