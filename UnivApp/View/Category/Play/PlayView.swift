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
    @State var searchText: String
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                search
                    .padding(.bottom, 20)
                    .padding(.top, 10)
                
                Spacer()
                
                ScrollView(.vertical) {
                    page
                    list
                }
                .padding(.horizontal, 0)
                .padding(.bottom, 0)
                .refreshable {
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Text("놀거리")
                            .font(.system(size: 15, weight: .heavy))
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                        Image("play")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .padding(.trailing, 10)
                    }
                    .background(.pink)
                    .cornerRadius(15)
                    .padding(.trailing, 20)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image("back")
                    })
                }
            }
        }
        .navigationBarBackButtonHidden(true)
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
    
    var search: some View {
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
    }
    
    var page: some View {
        TabView {
            ForEach(viewModel.playStub, id: \.self) { cell in
                if let image = cell.image, let title = cell.title, let address = cell.address, let description = cell.description {
                    HStack(spacing: 20) {
                        PlayViewCell(title: title, address: address, description: description, image: image)
                            .tag(cell.id)
                    }
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .frame(height: 250)
        .padding(.horizontal, 0)
    }
    
    var list: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            ForEach(viewModel.stub, id: \.self) { cell in
                if let image = cell.image, let title = cell.title, let heartNum = cell.heartNum {
                    HStack(spacing: 20) {
                        ListViewCell(image: image, title: title, heartNum: heartNum, heart: false)
                            .tag(cell.id)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

struct PlayView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices(authService: StubAuthService()))
    static let authViewModel = AuthViewModel(container: .init(services: StubServices(authService: StubAuthService())))
    static var previews: some View {
        PlayView(viewModel: PlayViewModel(container: Self.container), searchText: .init())
            .environmentObject(Self.authViewModel)
            .environmentObject(Self.container)
    }
}

