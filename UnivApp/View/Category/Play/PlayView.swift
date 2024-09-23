//
//  PlayView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import SwiftUI

struct PlayView: View {
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: PlayViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var currentIndex: Int = 0
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        contentView
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            //TODO: - ExchangeView
            loadedView
                .onAppear {
                    //TODO: - load
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
            VStack(spacing: 20) {
                ScrollView(.vertical) {
                    
                    header
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    list
                }
                .padding(.horizontal, 0)
                .padding(.bottom, 0)
                .refreshable {
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 0) {
                        Button(action: {
                            dismiss()
                        }, label: {
                            //TODO: - whiteback 추가
                            Image("blackback")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            Image("play_navi")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 60)
                        })
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
    
    var header: some View {
        VStack(alignment: .leading, spacing: 30) {
            Image("play_poster")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
            
            Text("핫플 추천 🔥")
                .font(.system(size: 18, weight: .bold))
                .padding(.leading, 20)
            
            TabView(selection: $currentIndex) {
                ForEach(viewModel.hotplaceData.indices, id: \.self) { index in
                    representativePlaceCell(model: viewModel.hotplaceData[index])
                        .tag(index)
                }
            }
            .frame(height: 200)
            .background(.white)
            .tabViewStyle(PageTabViewStyle())
            .onAppear {
                UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGray
                UIPageControl.appearance().currentPageIndicatorTintColor = .darkGray
            }
            .onDisappear {
                UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGray
                UIPageControl.appearance().currentPageIndicatorTintColor = .white
            }
            .onReceive(timer) { _ in
                withAnimation {
                    currentIndex = (currentIndex + 1) % viewModel.hotplaceData.count
                }
            }
        }
    }
    
    var list: some View {
        VStack(alignment: .leading, spacing: 30) {
            HScrollView(title: [Text("대학 주변의 "), Text("핫플 "), Text("확인하기")], array: [Object(title: "세종대학교", image: "emptyLogo"), Object(title: "세종대학교", image: "emptyLogo"), Object(title: "세종대학교", image: "emptyLogo"), Object(title: "세종대학교", image: "emptyLogo"), Object(title: "세종대학교", image: "emptyLogo")], pointColor: .pink, size: 60)
                .padding(.horizontal, -20)
            
            SeperateView()
                .frame(height: 20)
            
            Text("학교 목록")
                .font(.system(size: 18, weight: .bold))
                .padding(.leading, 20)
            HStack {
                Group {
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
                        .font(.system(size: 17, weight: .regular))
                        .padding()
                }
                .padding(.leading, 10)
            }
            .background(Color.homeColor)
            .cornerRadius(15)
            .padding(.horizontal, 20)
            
            
            ForEach(viewModel.playStub, id: \.self) { item in
                PlayViewCell(title: item.title ?? "", address: item.address ?? "", description: item.description ?? "", image: item.image ?? "")
                    .padding(.horizontal, 0)
                    .frame(height: 100)
            }
        }
        .padding(.top, 20)
    }
}

fileprivate struct representativePlaceCell: View {
    var model: PlayModel
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 20) {
                Image(model.image ?? "")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
                    .frame(width: proxy.size.width / 3, height: proxy.size.width / 3)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(model.title ?? "")
                        .font(.system(size: 12, weight: .bold))
                    
                    Text(model.description ?? "")
                        .font(.system(size: 10, weight: .semibold))
                        .lineSpacing(5)
                    
                    Text("📍 \(model.address ?? "")")
                        .font(.system(size: 10, weight: .regular))
                }
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, 23)
            .padding(.horizontal, 20)
        }
        .background(.white)
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
    }
}

struct PlayView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices())
    static let authViewModel = AuthViewModel(container: .init(services: StubServices()))
    static var previews: some View {
        PlayView(viewModel: PlayViewModel(container: Self.container, searchText: ""))
            .environmentObject(Self.authViewModel)
            .environmentObject(Self.container)
    }
}

