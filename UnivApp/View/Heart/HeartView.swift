//
//  HeartView.swift
//  UnivApp
//
//  Created by 정성윤 on 8/23/24.
//

import SwiftUI

struct HeartView: View {
    @State var searchText: String
    @StateObject var viewModel: HeartViewModel
    @EnvironmentObject var continer: DIContainer
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                search
                    .padding(.bottom, 20)
                
                Spacer()
                
                list
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("logo")
                }
            }
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
    
    var list: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(viewModel.stub, id: \.self) { cell in
                    if let image = cell.image, let title = cell.title, let heartNum = cell.heartNum {
                        HStack(spacing: 20) {
                            ListCellView(image: image, title: title, heartNum: heartNum, heart: false)
                                .tag(cell.id)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .padding(.horizontal, 0)
        .padding(.bottom, 0)
        .refreshable {
            
        }
    }
}

struct HeartView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices(authService: StubAuthService()))
    static let authViewModel = AuthViewModel(container: .init(services: StubServices(authService: StubAuthService())))
    static var previews: some View {
        HeartView(searchText: .init(), viewModel: HeartViewModel(container: Self.container))
            .environmentObject(Self.authViewModel)
            .environmentObject(Self.container)
    }
}
