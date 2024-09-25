//
//  FoodDetailView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/5/24.
//

import SwiftUI

struct FoodDetailView: View {
    @StateObject var viewModel: FoodDetailViewModel
    var body: some View {
        contentView
    }
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            PlaceholderView()
        case .loading:
            LoadingView(url: "congratulations", size: [150, 150])
        case .success:
            loadedView
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        VStack {
            TabView {
                
            }
        }
    }
}

#Preview {
    FoodDetailView(viewModel: FoodDetailViewModel())
}
