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

#Preview {
    MainTabView(mainTabViewModel: MainTabViewModel())
}
