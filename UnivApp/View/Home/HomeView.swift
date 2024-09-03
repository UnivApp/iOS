//
//  HomeView.swift
//  UnivApp
//
//  Created by 정성윤 on 8/23/24.
//

import SwiftUI

struct HomeView: View {
    @State var searchText: String
    @StateObject var viewModel: HomeViewModel
    @EnvironmentObject var continer: DIContainer
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                Spacer()
                
                headerView
                
                Spacer()
                
                categoryView
                    .padding(.bottom, 30)
                
                Spacer()
                
                footerView
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        //TODO: 알림
                    }, label: {
                        Image("bell")
                    })
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("logo")
                }
            }
        }
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .black
            UIPageControl.appearance().pageIndicatorTintColor = .gray
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.white
            appearance.shadowColor = nil
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var headerView: some View {
        VStack(alignment: .center, spacing: 5) {
            HStack {
                Button {
                    //TODO: 검색
                } label: {
                    Image("search")
                }
                .padding()
                
                TextField("대학명을 입력하세요", text: $searchText)
                    .padding()
            }
            .padding(.horizontal, 10)
            .background(Color(.backGray))
            .cornerRadius(15)
            .padding(.horizontal, 30)
            
            //임시 이미지
            TabView {
                ForEach(0..<3) { index in
                    Image("TestAd")
                        .resizable()
                        .scaledToFill()
                        .padding(.horizontal, 30)
                        .frame(height: 150)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                }
            }
            .frame(height: 250)
            .tabViewStyle(PageTabViewStyle())
        }
    }
    
    var categoryView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("카테고리")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.gray)
                .padding(.leading, 20)
                
            
            let columns = Array(repeating: GridItem(.flexible()), count: 4)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(CategoryType.allCases, id: \.self) { category in
                    NavigationLink(destination: category.view) {
                        VStack {
                            Image(category.imageName())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            Text(category.title)
                                .foregroundColor(.black)
                                .font(.system(size: 8, weight: .regular))
                        }
                    }
                    .environmentObject(continer)
                    .environmentObject(authViewModel)
                }
            }
            .padding(.horizontal, 5)
        }
    }
    
    var footerView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("입결")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.gray)
                    .padding(.leading, 20)
                    
                Spacer()
                
                NavigationLink(destination: EmptyView()) {
                    Image("arrow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                }
                .padding(.trailing, 20)
            }
            .padding(.horizontal, 5)
            
            Image("group")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 5)
                .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 5)
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices(authService: StubAuthService()))
    static let authViewModel = AuthViewModel(container: .init(services: StubServices(authService: StubAuthService())))
    static var previews: some View {
        HomeView(searchText: .init(), viewModel: HomeViewModel(container: Self.container))
            .environmentObject(Self.authViewModel)
            .environmentObject(Self.container)
    }
}
