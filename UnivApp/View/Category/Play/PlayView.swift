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
    
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.vertical) {
                    
                    header
                    
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
                            Image("blackback")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                        })
                        Image("food_navi")
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
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.white
            appearance.shadowColor = nil
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var header: some View {
        VStack(spacing: 30) {
            Image("play_poster")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 235)
                .padding(.vertical, 30)
            
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
    }
    
    var list: some View {
        VStack(alignment: .leading, spacing: 10) {
            HScrollView(title: [Text("대학 주변의 "), Text("핫플 "), Text("확인하기")], array: [Object(title: "세종대학교", image: "emptyLogo"), Object(title: "세종대학교", image: "emptyLogo"), Object(title: "세종대학교", image: "emptyLogo"), Object(title: "세종대학교", image: "emptyLogo"), Object(title: "세종대학교", image: "emptyLogo")], pointColor: .pink)

            
        }
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

