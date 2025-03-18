//
//  MainTabView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/17/25.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: TabBarType = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(TabBarType.allCases, id: \.self) { tab in
                Group {
                    switch tab {
                    case .home:
                        HomeView(viewModel: HomeViewModel())
                        
                    case .timeTable:
                        TimeTableView(viewModel: TimeTableViewModel())
                        
                    case .chat:
                        Color.white
                        
                    case .todo:
                        ToDoListView(viewModel: ToDoListViewModel())
                        
                    case .profile:
                        Color.white
                    }
                }
                .tabItem {
                    Image(systemName: tab.sfSymbol)
                }
                .tag(tab)
            }
        }
        .onAppear {
            let apperance = UINavigationBarAppearance()
            apperance.backgroundColor = UIColor(.white)
            apperance.shadowColor = nil
            UINavigationBar.appearance().standardAppearance = apperance
            UINavigationBar.appearance().scrollEdgeAppearance = apperance
            
            let tabApperance = UITabBarAppearance()
            tabApperance.backgroundColor = .white
            tabApperance.shadowColor = nil
            UITabBar.appearance().standardAppearance = tabApperance
            UITabBar.appearance().scrollEdgeAppearance = tabApperance
            
            UIPageControl.appearance().isHidden = true
            UIPageControl.appearance().currentPageIndicatorTintColor = .clear
            UIPageControl.appearance().pageIndicatorTintColor = .clear
            UIPageControl.appearance().tintColor = .clear
            UIPageControl.appearance().backgroundColor = .clear
        }
        .tint(.black)
        .background(.white)
    }
}

#Preview {
    TabBarView()
}
