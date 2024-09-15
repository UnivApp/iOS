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
    @FocusState private var isFocused: Bool
    
    var body: some View {
        contentView
        //            .onTapGesture {
        //                self.isFocused = false
        //            }
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
                VStack(alignment: .center, spacing: 20) {
                    headerView
                        .padding(.top, 10)
                    
                    categoryView
                    
                    footerView
                        .padding(.top, 10)
                }
                .padding(.horizontal, 30)
            }
            .background(Color.white)
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
    }
    
    var headerView: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                Button {
                    //TODO: 검색
                    
                } label: {
                    Image("search")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                }
                .padding()
                
                TextField("대학명/소재지를 입력하세요", text: $viewModel.searchText)
                    .focused($isFocused)
                    .font(.system(size: 17, weight: .regular))
                    .padding()
            }
            .background(Color.homeColor)
            .cornerRadius(15)
            
            CalendarContainer(eventDates: [
                Calendar.current.startOfDay(for: Date()): UIImage(named: "star")!
            ])
            .frame(height: 300)
            .background(.white)
        }
    }
    
    var categoryView: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text("카테고리")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.gray)
                .padding(.leading, 20)
                .padding(.bottom, 10)
            
            
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
        }
    }
    
    var footerView: some View {
        VStack(alignment: .center, spacing: 10) {
            
            //TODO: - 구글 애드몹
            
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
            
            //TODO: - 입결 리스트 불러오기
            ForEach(viewModel.InitiativeData, id: \.rank) { item in
                InitiativeViewCell(model: item)
                    .padding(.horizontal, -30)
            }
            
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
