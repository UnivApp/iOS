//
//  MainTabView.swift
//  UnivApp
//
//  Created by 정성윤 on 8/22/24.
//

import SwiftUI
import AdFitSDK

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var container: DIContainer
    @StateObject var mainTabViewModel : MainTabViewModel
    @State private var selectedTab: MainTabType = .home
    
//    init(selectedTab: MainTabType) {
//        self.selectedTab = selectedTab
//        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.black)
//    }
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(MainTabType.allCases, id: \.self) { tab in
                Group {
                    switch tab {
                    case .home:
                        HomeView(searchText: "")
                    case .list:
                        ListView()
                    case .heart:
                        HeartView()
                    case .setting:
                        SettingView()
                    }
                }
                .tabItem {
                    Label(tab.title, image: tab.imageName(selected: selectedTab == tab))
                }
                .tag(tab)
            }
        }
        .tint(.black)
    }
    
}

struct MainTabView_Preview: PreviewProvider {
    static let container: DIContainer = .init(services: StubServices(authService: StubAuthService()))
    static let authViewModel: AuthViewModel = AuthViewModel(container: .init(services: StubServices(authService: StubAuthService())))
    
    static var previews: some View {
        MainTabView(mainTabViewModel: MainTabViewModel())
            .environmentObject(container)
            .environmentObject(authViewModel)
    }
}
