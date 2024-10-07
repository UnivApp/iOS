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
                        HomeView(viewModel: HomeViewModel(container: self.container), listViewModel: ListViewModel(container: self.container, searchText: ""))
                            .environmentObject(authViewModel)
                            .environmentObject(container)
                    case .list:
                        ListView(viewModel: ListViewModel(container: self.container, searchText: .init()))
                            .environmentObject(authViewModel)
                            .environmentObject(container)
                    case .calendar:
                        CalendarContainer(viewModel: CalendarViewModel(), eventDates: [
                            Calendar.current.startOfDay(for: Date()): UIImage(named: "star")!
                        ])
                        .environmentObject(authViewModel)
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
                    UINavigationBar.appearance().backgroundColor = .clear
                    UIPageControl.appearance().isHidden = true
                }
            }
        }
        .tint(.black)
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
