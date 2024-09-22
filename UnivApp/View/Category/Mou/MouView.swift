//
//  MouView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import SwiftUI

struct MouView: View {
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: MouViewModel
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationStack {
            VStack {
                search
                    .padding(.bottom, 20)
                    .padding(.top, 20)
                
                Spacer()
                
                ScrollView(.vertical) {
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
                            Image("blackback")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                        })
                        Image("mou_navi")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 60)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
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
            Group {
                Button {
                    //TODO: 검색
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
            .padding(.leading, 10)
        }
        .background(Color(.backGray))
        .cornerRadius(15)
        .padding(.horizontal, 30)
    }
    
    var list: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
//            ForEach(viewModel.stub, id: \.self) { cell in
//                if let image = cell.image, let title = cell.title, let heartNum = cell.heartNum {
//                    HStack(spacing: 20) {
//                        ListViewCell(id: 0, image: image, title: title, heartNum: heartNum, destination: .mou, heart: false, listViewModel: ListViewModel(container: .init(services: StubServices()), searchText: ""))
//                            .tag(cell.id)
//                    }
//                }
//            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

struct MouView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices())
    static let authViewModel = AuthViewModel(container: .init(services: StubServices()))
    static var previews: some View {
        MouView(viewModel: MouViewModel(searchText: "", container: Self.container))
            .environmentObject(Self.authViewModel)
            .environmentObject(Self.container)
    }
}

