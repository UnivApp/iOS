//
//  ListView.swift
//  UnivApp
//
//  Created by 정성윤 on 8/23/24.
//

import SwiftUI

struct ListView: View {
    @StateObject var viewModel: ListViewModel
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
        .onAppear {
            viewModel.send(action: .load)
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
            
            TextField("대학명/소재지를 입력하세요", text: $viewModel.searchText)
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
                ForEach(viewModel.summaryArray, id: \.fullName) { cell in
                    if let image = cell.logo, let title = cell.fullName, let heartNum = cell.starNum {
                        HStack(spacing: 20) {
                            ListViewCell(image: image, title: title, heartNum: "\(heartNum)", destination: .list, heart: false)
                                .tag(cell.fullName)
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

struct ListView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices())
    static let authViewModel = AuthViewModel(container: .init(services: StubServices()))
    static var previews: some View {
        ListView(viewModel: ListViewModel(container: self.container, searchText: ""))
            .environmentObject(Self.authViewModel)
            .environmentObject(Self.container)
    }
}
