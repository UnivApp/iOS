//
//  FoodHotPlaceView.swift
//  UnivApp
//
//  Created by 정성윤 on 10/7/24.
//

import SwiftUI
import Kingfisher

struct FoodHotPlaceView: View {
    var model: [FoodModel]
    var body: some View {
        ScrollView(.vertical) { 
            VStack(alignment: .center, spacing: 20) {
                HStack {
                    Text("대학 주변 ")
                    + Text("맛집")
                        .foregroundColor(.orange)
                    + Text(" 확인하기")
                    Spacer()
                }
                .font(.system(size: 18, weight: .bold))
                .padding(.horizontal, 30)
                
                ForEach(model, id: \.self) { cell in
                    FoodHotPlaceCell(cell: cell)
                }
            }
        }
    }
}

fileprivate struct FoodHotPlaceCell: View {
    var cell: FoodModel
    var body: some View {
        HStack(spacing: 20) {
            KFImage(URL(string: cell.imageUrl ?? ""))
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .background(.gray)
                .cornerRadius(15)
            VStack(spacing: 10) {
                Text(cell.name)
                    .font(.system(size: 18, weight: .bold))
                
                HStack {
                    ForEach(cell.hashtags, id: \.self) { hashtag in
                        Text("#\(hashtag)")
                    }
                }
                .font(.system(size: 12, weight: .semibold))
                
            }.multilineTextAlignment(.leading)
        }.padding(.horizontal, 30)
    }
}

#Preview {
    FoodHotPlaceView(model: [FoodModel(name: "깍뚝", location: "서울특별시 광진구 동일로", placeUrl: "", hashtags: ["삼겹살", "가브리살", "무한리필"], imageUrl: "", topMessage: "세종대학교 1등 맛집")])
}
