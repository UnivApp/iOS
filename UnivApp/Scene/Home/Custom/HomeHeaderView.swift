//
//  HomeHeaderView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/17/25.
//

import SwiftUI

struct HomeHeaderView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            HomeProfileView()
            
            let columns = Array(repeating: GridItem(.flexible()), count: 4)
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(HomeCategoryType.allCases, id: \.self) { category in
                    //TODO: 이동
                    NavigationLink(destination: EmptyView()) {
                        VStack {
                            Image(systemName: category.image)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.point)
                                .frame(width: 30, height: 30)
                            
                            Text(category.rawValue)
                                .foregroundColor(.gray)
                                .font(.system(size: 10, weight: .semibold))
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
    }
}


#Preview {
    HomeHeaderView()
        .environmentObject(HomeViewModel())
}
