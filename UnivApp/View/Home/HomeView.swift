//
//  HomeView.swift
//  UnivApp
//
//  Created by 정성윤 on 8/23/24.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: HomeViewModel
    
    @State private var selectedSegment: SplitType = .employment
    @State private var isShowingPopup: Bool = false
    
    var body: some View {
        NavigationStack {
            loadedView
                .background(.white)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("TeenSpot")
                            .foregroundColor(.black)
                            .font(.system(size: 25, weight: .heavy))
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack(spacing: 16) {
                            Button {
                                // TODO: Navigation
                            } label: {
                                Image(systemName: "magnifyingglass")
                            }
                            
                            Button {
                                // TODO: Navigation
                            } label: {
                                Image(systemName: "bell")
                            }
                        }
                        .tint(.primary)
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
                    viewModel.send(action: .load)
                }
        case .loading:
            LoadingView(url: "congratulations", size: [150, 150])
        case .success:
            loadedView
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center, spacing: 12) {
                HomeHeaderView()
                    .environmentObject(viewModel)
                
                HomeMiddleView()
                    .environmentObject(viewModel)
                
                HomeFooterView(selectedSegment: $selectedSegment)
                    .environmentObject(viewModel)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices())
    static let authViewModel = AuthViewModel(container: .init(services: StubServices()), authState: .auth)
    
    static var previews: some View {
        HomeView(viewModel: HomeViewModel(container: Self.container))
            .environmentObject(AuthViewModel(container: .init(services: StubServices()), authState: .auth))
    }
}
