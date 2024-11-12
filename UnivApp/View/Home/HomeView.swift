//
//  HomeView.swift
//  UnivApp
//
//  Created by 정성윤 on 8/23/24.
//

import SwiftUI
import Kingfisher

struct HomePopupModel {
    var isPresented: Bool
    var type: HomePopupType?
    
    enum HomePopupType {
        case search
        case alert
        case chat
    }
}

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @StateObject var listViewModel: ListViewModel
    
    @State private var isLoading: Bool = false
    @State private var selectedSegment: SplitType = .employment
    @State private var isShowingPopup: HomePopupModel = .init(isPresented: false)
    @FocusState private var isFocused: Bool
    
    @State private var currentIndex: Int = 0
    @State private var popupOpacity: [Bool] = [false, false, false]
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        loadedView
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
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 10) {
                    searchView
                        .padding(.top, 10)
                    
                    categoryView
                    
                    footerView
                }
            }
            .fullScreenCover(isPresented: $isShowingPopup.isPresented) {
                if isShowingPopup.type == .alert {
                    BellView(viewModel: CalendarViewModel(container: .init(services: Services())), isPopup: $isShowingPopup.isPresented)
                        .fadeInOut($popupOpacity[0])
                } else if isShowingPopup.type == .search {
                    PopUpContentView(summary: listViewModel.summaryArray, isShowingPopup: $isShowingPopup.isPresented)
                        .cornerRadius(15)
                        .padding(.horizontal, 20)
                        .presentationBackground(.black.opacity(0.3))
                        .fadeInOut($popupOpacity[1])
                } else {
                    ChatView(viewModel: ChatViewModel(container: .init(services: Services())))
                        .fadeInOut($popupOpacity[2])
                }
            }
            .transaction { $0.disablesAnimations = true }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingPopup = .init(isPresented: true, type: .alert)
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
                            isShowingPopup = .init(isPresented: true, type: .search)
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
                    .submitLabel(.search)
                    .onSubmit {
                        listViewModel.send(action: .search)
                        listViewModel.searchText = ""
                        isFocused = false
                        withAnimation {
                            isShowingPopup = .init(isPresented: true, type: .search)
                        }
                    }
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
        VStack(alignment: .leading, spacing: 10) {
            
            let columns = Array(repeating: GridItem(.flexible()), count: 4)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(CategoryType.allCases, id: \.self) { category in
                    NavigationLink(destination: category.view) {
                        VStack {
                            Image(category.imageName())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                            Text(category.title)
                                .foregroundColor(.black)
                                .font(.system(size: 10, weight: .semibold))
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 20)
            
            TabView(selection: $currentIndex) {
                ForEach(viewModel.posterData.indices, id: \.self) { index in
                    Image(viewModel.posterData[index])
                        .resizable()
                        .scaledToFill()
                        .tag(index)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 40, height: (UIScreen.main.bounds.width - 40) / 3)
            .tabViewStyle(PageTabViewStyle())
            .onReceive(timer) { _ in
                withAnimation {
                    currentIndex = (currentIndex + 1) % viewModel.posterData.count
                }
            }
            .overlay(alignment: .bottomTrailing) {
                CustomPageControl(currentPage: $currentIndex, numberOfPages: viewModel.posterData.count)
                    .cornerRadius(15)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
            }
            .cornerRadius(15)
            .padding(.horizontal, 20)
            
            HScrollView(title: [Text("이런 "), Text("핫플 "), Text("어때요?")], pointColor: .orange, size: 100, playDeatilModel: PlayDetailModel(object: viewModel.convertToObjects(from: viewModel.topPlaceData), placeDataArray: viewModel.topPlaceData, placeData: nil))
        }
    }
    
    var footerView: some View {
        VStack(alignment: .center, spacing: 20) {
            SeperateView()
                .frame(width: UIScreen.main.bounds.width, height: 20)
            
            
            GADBannerViewController(type: .banner)
                .frame(width: UIScreen.main.bounds.width - 40, height: (UIScreen.main.bounds.width - 40) / 3.2)
            
            
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
    }
}
