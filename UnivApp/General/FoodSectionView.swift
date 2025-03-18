//
//  FoodSectionView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/17/25.
//

import SwiftUI

struct FoodSectionView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 24) {
                FoodItemView(title: "점심")
                FoodItemView(title: "저녁")
            }
            .padding(.horizontal, 24)
        }
    }
}

fileprivate struct FoodItemView: View {
    var title: String
    //TODO: Model
    var body: some View {
        Group {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(title)
                        .foregroundColor(.black)
                        .font(.system(size: 15, weight: .bold))
                    Spacer()
                    Text("720Kcal")
                        .foregroundColor(.primary)
                        .font(.system(size: 14, weight: .regular))
                }
                .padding(.horizontal, 24)
                
                
                ForEach(0...5, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("돼지고기김치볶음")
                            .lineLimit(1)
                            .foregroundColor(.gray)
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .padding(.horizontal, 24)
                }
            }
            .padding(.vertical, 12)
        }
        .frame(width: 300, height: 200)
        .background(.white)
        .clipped()
        .cornerRadius(15)
        .shadow(radius: 0.7)
        .padding(.vertical, 8)
    }
}

#Preview {
    FoodSectionView()
}
