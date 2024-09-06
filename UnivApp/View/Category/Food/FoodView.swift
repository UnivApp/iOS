//
//  FoodView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import SwiftUI

struct FoodView: View {
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: FoodViewModel
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
            Image("food_poster")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 235)
                .padding(.top, 20)
            
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
            Group {
                Text("대학 주변 ")
                    .font(.system(size: 15, weight: .bold))
                + Text("맛집")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.orange)
                + Text(" 확인하기")
                    .font(.system(size: 15, weight: .bold))
            }
            .padding(.horizontal, 30)
            .padding(.top, 10)

            ForEach(viewModel.stub, id: \.self) { food in
                if let title = food.title,
                   let description = food.description,
                   let image = food.image,
                   let school = food.school {
                    FoodViewCell(title: title, description: description, image: image, school: school, view: AnyView(EmptyView()))
                }
            }
        }
    }
}

struct FoodView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices(authService: StubAuthService()))
    static let authViewModel = AuthViewModel(container: .init(services: StubServices(authService: StubAuthService())))
    static var previews: some View {
        FoodView(viewModel: FoodViewModel(searchText: "", container: Self.container))
            .environmentObject(Self.authViewModel)
            .environmentObject(Self.container)
    }
}

