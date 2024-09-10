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
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        contentView
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear{
                    viewModel.send(action: .load)
                }
        case .loading:
            LoadingView(url: "congratulations")
        case .success:
            loadedView
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("알림 🔔"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("확인"))
                    )
                }
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                search
                    .padding(.bottom, 20)
                
                Spacer()
                
                ZStack {
                    
                    if viewModel.notFound == true {
                        Text("학교를 찾을 수 없습니다. 🧐")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.gray)
                    }
                    
                    list
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("logo")
                }
            }
            .onChange(of: viewModel.heartPhase) {
                switch viewModel.heartPhase {
                case .notRequested:
                    self.showAlert = false
                    self.alertMessage = ""
                case .addHeart:
                    self.showAlert = true
                    self.alertMessage = "관심대학으로 등록되었습니다."
                case .removeHeart:
                    self.showAlert = true
                    self.alertMessage = "관심대학이 삭제되었습니다."
                }
            }
        }
    }
    
    var search: some View {
        HStack {
            Button {
                viewModel.send(action: .search)
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
                            ListViewCell(image: image, title: title, heartNum: "\(heartNum)", destination: .list, heart: false, listViewModel: self.viewModel)
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
            viewModel.send(action: .load)
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
