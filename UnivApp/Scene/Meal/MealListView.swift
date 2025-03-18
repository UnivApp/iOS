//
//  MealListView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/18/25.
//

import SwiftUI

struct MealListView: View {
    @StateObject var viewModel: MealListViewModel
    
    var body: some View {
        loadedView
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear {
                    
                }
        case .loading:
            LoadingView()
        case .success:
            loadedView
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        List {
            ForEach(15...26, id: \.self) { index in
                Group {
                    Text("3월 \(index)일 (토요일)")
                        .foregroundColor(.primary)
                        .font(.system(size: 17, weight: .bold))
                        .padding(.horizontal, 8)
                }
                .frame(height: 40)
                .background(.white)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    MealListView(viewModel: MealListViewModel())
}
