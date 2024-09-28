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
    @StateObject var listViewModel: ListViewModel
    @EnvironmentObject var continer: DIContainer
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var isLoading: Bool = false
    @State private var selectedSegment: SplitType = .employment
    @FocusState private var isFocused: Bool
    
    @State private var currentIndex: Int = 0
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
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
            //TODO: - 변경
            loadedView
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
                VStack(alignment: .center, spacing: 20) {
                    SearchView(searchText: $viewModel.searchText)
                        .padding(.top, 10)
                        .environmentObject(listViewModel)
                    
                    categoryView
                    
                    footerView
                }
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
    
    var categoryView: some View {
        VStack(alignment: .leading, spacing: 15) {
            
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
                                .font(.system(size: 10, weight: .semibold))
                        }
                    }
                    .environmentObject(continer)
                    .environmentObject(authViewModel)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 20)
            
            TabView(selection: $currentIndex) {
                ForEach(viewModel.posterData.indices, id: \.self) { index in
                    //TODO: - NavigationLink
                    Image(viewModel.posterData[index])
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 3)
                        .tag(index)
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 3)
            .tabViewStyle(PageTabViewStyle())
            .onReceive(timer) { _ in
                withAnimation {
                    currentIndex = (currentIndex + 1) % viewModel.posterData.count
                }
            }
            .overlay(alignment: .bottomTrailing) {
                CustomPageControl(currentPage: $currentIndex, numberOfPages: viewModel.posterData.count)
            }
            
            HScrollView(title: [Text("이런 "), Text("핫플 "), Text("어때?")], array: [Object(title: "어린이대공원", image: "hotplace1"),Object(title: "롯데월드", image: "hotplace2"),Object(title: "올림픽공원", image: "hotplace3"),Object(title: "서울숲", image: "hotplace4"),Object(title: "어린이대공원", image: "hotplace1"),Object(title: "롯데월드", image: "hotplace2")], pointColor: .orange, size: 100)
        }
    }
    
    var footerView: some View {
        VStack(alignment: .center, spacing: 20) {
            SeperateView()
                .frame(width: UIScreen.main.bounds.width, height: 20)
            
            
            //TODO: - 구글 애드몹
            
            Group {
                HStack {
                    Text("경쟁률")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
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
                }
            }.padding(.horizontal, 20)
            
            //TODO: - 입결 리스트 불러오기
            VStack {
                HStack(spacing: 10) {
                    ForEach(SplitType.allCases, id: \.self) { item in
                        Button(action: {
                            selectedSegment = item
                        }) {
                            Text(item.title)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(selectedSegment == item ? .black : .gray)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(selectedSegment == item ? Color.yellow : Color.clear)
                                        .frame(height: 40))
                                .cornerRadius(15)
                        }
                    }
                }
                .padding()
                
                Group {
                    switch selectedSegment {
                    case .employment:
                        ForEach(viewModel.InitiativeData, id: \.rank) { cell in
                            InitiativeViewCell(model: cell)
                                .tag(cell.rank)
                        }.padding(.horizontal, -20)
                    case .Occasion:
                        EmptyView()
                    case .ontime:
                        EmptyView()
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices())
    static let authViewModel = AuthViewModel(container: .init(services: StubServices()))
    static var previews: some View {
        HomeView(viewModel: HomeViewModel(container: Self.container, searchText: ""), listViewModel: ListViewModel(container: Self.container, searchText: ""))
            .environmentObject(Self.authViewModel)
            .environmentObject(Self.container)
    }
}
