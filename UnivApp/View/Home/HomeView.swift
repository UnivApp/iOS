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
    @State private var isShowingPopup: Bool = false
    @FocusState private var isFocused: Bool
    
    @State private var currentIndex: Int = 0
    @State private var popupOpacity: Double = 0
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        contentView
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear {
                    viewModel.send(action: .load)
                }
        case .loading:
            LoadingView(url: "congratulations", size: [150, 150])
        case .success:
            loadedView
                .onAppear {
                    listViewModel.searchText = ""
                }
                .onDisappear {
                    listViewModel.searchText = ""
                }
                .onTapGesture {
                    self.isFocused = false
                }
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        NavigationStack {
            ZStack {
                ScrollView(.vertical) {
                    VStack(alignment: .center, spacing: 20) {
                        searchView
                            .padding(.top, 10)
                        
                        categoryView
                        
                        footerView
                    }
                }
            }
            .fullScreenCover(isPresented: $isShowingPopup) {
                PopUpContentView(summary: listViewModel.summaryArray, isShowingPopup: $isShowingPopup)
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                    .presentationBackground(.black.opacity(0.3))
                    .onAppear {
                        withAnimation {
                            popupOpacity = 1
                        }
                    }
                    .onDisappear {
                        withAnimation {
                            popupOpacity = 0
                        }
                    }
                    .opacity(popupOpacity)
                    .animation(.easeInOut, value: popupOpacity)
            }
            .transaction { $0.disablesAnimations = true }
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
    
    var searchView: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                Button {
                    if listViewModel.searchText != "" {
                        listViewModel.send(action: .search)
                        withAnimation {
                            isShowingPopup = true
                        }
                    }
                    listViewModel.searchText = ""
                } label: {
                    Image("search")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                }
                .padding()
                
                TextField("대학명/소재지를 입력하세요", text: $listViewModel.searchText)
                    .focused($isFocused)
                    .font(.system(size: 15, weight: .regular))
                    .padding()
            }
            .padding(.horizontal, 10)
            .background(Color.white)
            .border(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .leading, endPoint: .trailing), width: 1)
            .cornerRadius(15)
            .overlay (
                RoundedRectangle(cornerRadius: 15)
                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .leading, endPoint: .trailing), lineWidth: 1.5)
            )
        }
        .padding(.horizontal, 20)
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
            
            HScrollView(title: [Text("이런 "), Text("핫플 "), Text("어때요?")], pointColor: .orange, size: 100, playDeatilModel: PlayDetailModel(object: viewModel.convertToObjects(from: viewModel.topPlaceData), placeDataArray: viewModel.topPlaceData, placeData: nil))
        }
    }
    
    var footerView: some View {
        VStack(alignment: .center, spacing: 20) {
            SeperateView()
                .frame(width: UIScreen.main.bounds.width, height: 20)
            
            
            //TODO: - 구글 애드몹
            
            
            RateView(rateViewModel: RateViewModel(container: .init(services: Services())), selectedSegment: $selectedSegment)
                .environmentObject(self.viewModel)
                .padding(.bottom, 30)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices())
    static let authViewModel = AuthViewModel(container: .init(services: StubServices()), authState: .auth)
    static var previews: some View {
        HomeView(viewModel: HomeViewModel(container: Self.container), listViewModel: ListViewModel(container: Self.container, searchText: ""))
            .environmentObject(Self.authViewModel)
            .environmentObject(Self.container)
    }
}
