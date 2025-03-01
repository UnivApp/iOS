//
//  MainTabView.swift
//  UnivApp
//
//  Created by 정성윤 on 8/22/24.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var container: DIContainer
    @State private var selectedTab: MainTabType = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(MainTabType.allCases, id: \.self) { tab in
                Group {
                    switch tab {
                    case .home:
                        HomeView(viewModel: HomeViewModel(container: self.container))
                            .environmentObject(authViewModel)
                        
                    case .calendar:
                        CalendarContainer(viewModel: CalendarViewModel(container: self.container))
                            .environmentObject(authViewModel)
                        
                    case .list:
                        PlaceholderView()
                            .environmentObject(authViewModel)
                        
                    case .todo:
                        PlaceholderView()
                            .environmentObject(authViewModel)
                        
                    case .profile:
                        SettingView(viewModel: SettingViewModel(container: self.container))
                            .environmentObject(authViewModel)
                    }
                }
                .tabItem {
                    Image(tab.imageName(selectedTab.isEqual(tab)))
                }
            }
        }
        .onAppear {
            let apperance = UINavigationBarAppearance()
            apperance.backgroundColor = UIColor(Color.backPointColor)
            apperance.shadowColor = nil
            UINavigationBar.appearance().standardAppearance = apperance
            UINavigationBar.appearance().scrollEdgeAppearance = apperance
            
            UIPageControl.appearance().isHidden = true
            UIPageControl.appearance().currentPageIndicatorTintColor = .clear
            UIPageControl.appearance().pageIndicatorTintColor = .clear
            UIPageControl.appearance().tintColor = .clear
            UIPageControl.appearance().backgroundColor = .clear
        }
        .tint(.black)
        .background(.white)
//        .clipShape(RoundedCornersShape(corners: [.topLeft, .topRight], radius: 15))
        
//        .fullScreenCover(isPresented: $authViewModel.isNicknamePopup) {
//            NickNameView(viewModel: SettingViewModel(container: container), isPresented: $authViewModel.isNicknamePopup, type: .create)
//                .presentationBackground(.black.opacity(0.7))
//        }
    }
    
}

struct MainTabView_Preview: PreviewProvider {
    static let container: DIContainer = .init(services: StubServices())
    static let authViewModel: AuthViewModel = AuthViewModel(container: .init(services: StubServices()), authState: .auth)
    
    static var previews: some View {
        MainTabView()
            .environmentObject(container)
            .environmentObject(authViewModel)
    }
}
