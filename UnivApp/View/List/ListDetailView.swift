//
//  ListDetailView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/5/24.
//

import SwiftUI

struct ListDetailView: View {
    @StateObject var viewModel: ListDetailViewModel
    @State private var selectedType: ListDetailType?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                info
                    .padding(.vertical, 30)
                
                category
                    .padding(.vertical, 0)
                    .padding(.horizontal, 0)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("back")
                    }

                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    var info: some View {
        HStack(spacing: 10) {
            Group {
                Image("emptyLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.leading, 10)
                VStack(alignment: .leading, spacing: 10) {
                    Text("세종대학교")
                        .font(.system(size: 15, weight: .bold))
                    
                    Text("서울특별시 광진구 능동로 209\n02-3408-3114\n2025학년도 입학안내\n전공설치학과 및 선발 정보 보기")
                        .font(.system(size: 12, weight: .regular))
                    
                    Text("메가스터디 제공")
                        .font(.system(size: 10, weight: .thin))
                }
                .padding(.trailing, 10)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 30)
        }
        .background(.white)
        .cornerRadius(15)
        .shadow(radius: 10)
    }
    
    var category: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                ForEach(ListDetailType.allCases, id: \.self) { type in
                    Button {
                        //TODO: 해당 섹션으로 이동
                        selectedType = type
                    } label: {
                        VStack {
                            Text(type.title)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(selectedType == type ? Color.gray : Color.white)
                                .frame(width: 50, height: proxy.size.height / 8)
                                .background(.clear)
                        }
                        .frame(maxWidth: 70, alignment: .center)
                        
                        HStack {
                            Group {
                                type.image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                
                                Text(type.description)
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(selectedType == type ? Color.white : Color.gray)
                            }
                            .frame(height: proxy.size.height / 8)
                            .padding(.leading, 30)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(selectedType == type ? Color.categoryGray : Color.white)
                    }
                    .background(selectedType == type ? Color.white : Color.categoryGray)
                }
            }
        }
    }
    
}

struct ListDetailView_PreViews: PreviewProvider {
    static var previews: some View {
        ListDetailView(viewModel: ListDetailViewModel(container: DIContainer(services: StubServices(authService: StubAuthService()))))
    }
}
