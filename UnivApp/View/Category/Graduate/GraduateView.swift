//
//  GraduateView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import SwiftUI

struct GraduateView: View {
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: GraduateViewModel
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
                            Image("back")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                        })
                        Image("graduate_navi")
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
            Image("graduate_poster")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 235)
                .padding(.vertical, 5)
            
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
            HScrollView(title: [Text("유명한 "), Text("선배 "), Text("확인하기 ")], array: [Object(title: "신혜선", image: "talent_empty"), Object(title: "신혜선", image: "talent_empty"), Object(title: "신혜선", image: "talent_empty"), Object(title: "신혜선", image: "talent_empty"), Object(title: "신혜선", image: "talent_empty")], pointColor: .orange)
            
            HScrollView(title: [Text("우리학교 "), Text("선배 "), Text("확인하기 ")], array: [Object(title: "세종대학교", image: "emptyLogo"), Object(title: "세종대학교", image: "emptyLogo"), Object(title: "세종대학교", image: "emptyLogo"), Object(title: "세종대학교", image: "emptyLogo"), Object(title: "세종대학교", image: "emptyLogo")], pointColor: .orange)
            
            HScrollView(title: [Text("유명한 "), Text("선배 "), Text("확인하기 ")], array: [Object(title: "신혜선", image: "talent_empty"), Object(title: "신혜선", image: "talent_empty"), Object(title: "신혜선", image: "talent_empty"), Object(title: "신혜선", image: "talent_empty"), Object(title: "신혜선", image: "talent_empty")], pointColor: .orange)
            
        }
    }
}

struct GraduateView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices())
    static let authViewModel = AuthViewModel(container: .init(services: StubServices()))
    static var previews: some View {
        GraduateView(viewModel: GraduateViewModel(searchText: "", container: Self.container))
            .environmentObject(Self.authViewModel)
            .environmentObject(Self.container)
    }
}
