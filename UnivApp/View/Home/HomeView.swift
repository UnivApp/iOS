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
        contentView
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
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 10) {
                    SearchView()
                    
                    HomeCategoryView()
                        .environmentObject(viewModel)
                    
                    HomeFooterView(selectedSegment: $selectedSegment)
                        .environmentObject(viewModel)
                }
            }
            .fullScreenCover(isPresented: $isShowingPopup) {
                BellView(viewModel: CalendarViewModel(container: .init(services: Services())), isPopup: $isShowingPopup)
                    .fadeInOut($isShowingPopup)
                    .environmentObject(authViewModel)
            }
            .transaction { $0.disablesAnimations = true }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingPopup = true
                    }, label: {
                        Image("bell")
                    })
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("logo")
                }
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
