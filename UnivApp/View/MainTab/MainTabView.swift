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
                        HomeView(viewModel: HomeViewModel(container: self.container, searchText: .init()))
                            .environmentObject(authViewModel)
                            .environmentObject(container)
                    case .list:
                        ListView(viewModel: ListViewModel(container: self.container, searchText: .init()))
                            .environmentObject(authViewModel)
                            .environmentObject(container)
                    case .heart:
                        HeartView(viewModel: HeartViewModel(container: self.container))
                            .environmentObject(authViewModel)
                            .environmentObject(container)
                    case .setting:
                        SettingView(viewModel: SettingViewModel(container: self.container))
                            .environmentObject(authViewModel)
                            .environmentObject(container)
                    }
                }
                .tabItem {
                    Label(tab.title, image: tab.imageName(selected: selectedTab == tab))
                }
                .tag(tab)
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    let appearance = UINavigationBarAppearance()
                    let tabBarAppearance = UITabBarAppearance()
                    appearance.configureWithOpaqueBackground()
                    appearance.backgroundColor = UIColor.white
                    appearance.shadowColor = nil
                    
                    UINavigationBar.appearance().standardAppearance = appearance
                    UINavigationBar.appearance().scrollEdgeAppearance = appearance
                    UITabBar.appearance().standardAppearance = tabBarAppearance
                    UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                    
                }
            }
        }
        .tint(.black)
    }
    
}

struct MainTabView_Preview: PreviewProvider {
    static let container: DIContainer = .init(services: StubServices())
    static let authViewModel: AuthViewModel = AuthViewModel(container: .init(services: StubServices()))
    
    static var previews: some View {
        MainTabView()
            .environmentObject(container)
            .environmentObject(authViewModel)
    }
}
