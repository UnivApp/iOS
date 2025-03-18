//
//  HomeView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/17/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationStack {
            loadedView
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("TeenSpot")
                    .foregroundColor(.primary)
                    .font(.system(size: 20, weight: .heavy))
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 12) {
                    Button {
                        //TODO: Search
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.primary)
                            .frame(width: 20, height: 20)
                    }
                    
                    Button {
                        //TODO: Bell
                    } label: {
                        Image(systemName: "bell.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.primary)
                            .frame(width: 20, height: 20)
                    }
                }
            }
        }
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
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 24) {
                HomeHeaderView()
                    .environmentObject(viewModel)
                
                HomeMiddleView()
                    .environmentObject(viewModel)
                
                HomeFooterView()
                    .environmentObject(viewModel)
            }
        }
        .background(.white)
    }
    
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
