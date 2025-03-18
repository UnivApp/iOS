//
//  MealDetailView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/18/25.
//

import SwiftUI

struct MealDetailView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            HStack {
                Text("급식표🍚")
                    .foregroundColor(.primary)
                    .font(.system(size: 18, weight: .heavy))
                Spacer()
            }
            
            FoodItemView(title: "점심")
            FoodItemView(title: "저녁")
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    MealDetailView()
}
