//
//  HomeView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/17/25.
//

import SwiftUI

struct HomeView: View {
    private let viewModel = HomeViewModel()
    var body: some View {
        loadedView
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear {
                    //TODO: 초기 데이터 로드
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
        VStack {
            
        }
    }
    
}

#Preview {
    HomeView()
}
