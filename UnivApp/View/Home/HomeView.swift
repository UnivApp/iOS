//
//  HomeView.swift
//  UnivApp
//
//  Created by 정성윤 on 8/23/24.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @EnvironmentObject var continer: DIContainer
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isLoading: Bool = false
    
    var body: some View {
        contentView
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            loadedView
                .onAppear {
                    viewModel.send(action: .load)
                }
        case .loading:
            LoadingView(url: "congratulations")
        case .success:
            loadedView
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
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
    }
        
    var headerView: some View {
        VStack(alignment: .center, spacing: 5) {
            HStack {
                Button {
                    //TODO: 검색
//                    self.isLoading = false
                } label: {
                    Image("search")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .padding()
                
                TextField("대학명/소재지를 입력하세요", text: $viewModel.searchText)
                    .font(.system(size: 17, weight: .bold))
                    .padding()
            }
            .padding(.horizontal, 10)
            .background(Color(.backGray))
            .cornerRadius(15)
            .padding(.horizontal, 30)
            
            //임시 이미지
            TabView {
                ForEach(viewModel.banners, id: \.image) { bannerItem in
                    KFImage(URL(string: bannerItem.image ?? ""))
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
                    HStack(spacing: 5) {
                        Text("더보기")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.gray)
                        
                        Image("arrow")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                    }
                }
                .padding(.trailing, 20)
            }
            .padding(.horizontal, 5)
            
            KFImage(URL(string: viewModel.scoreImage.image?[0] ?? ""))
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 5)
                .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 5)
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices())
    static let authViewModel = AuthViewModel(container: .init(services: StubServices()))
    static var previews: some View {
        HomeView(viewModel: HomeViewModel(container: Self.container, searchText: ""))
            .environmentObject(Self.authViewModel)
            .environmentObject(Self.container)
    }
}
