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
    @FocusState private var isFocused: Bool
    @State private var universityIdToScroll: Int? = nil
    
    var body: some View {
        contentView
            .onTapGesture {
                self.isFocused = false
            }
            .actionSheet(isPresented: $showAlert) {
                ActionSheet(
                    title: Text("알림 🔔"),
                    message: Text(alertMessage),
                    buttons: [.default(Text("확인"))]
                )
            }
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
            LoadingView(url: "congratulations", size: [150, 150])
        case .success:
            loadedView
                .onTapGesture {
                    self.isFocused = false
                }
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                SearchView(isFocused: self._isFocused, searchText: $viewModel.searchText)
                    .environmentObject(self.viewModel)
                    
                
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.send(action: .load)
                    } label: {
                        ZStack {
                            Image("refresh")
                                .padding()
                        }
                        .frame(width: 30, height: 30)
                        .background(Color.backGray)
                        .clipShape(Circle())
                    }
                }
            }
            .onChange(of: viewModel.heartPhase) {
                switch viewModel.heartPhase {
                case .notRequested:
                    self.showAlert = false
                    self.alertMessage = ""
                case .addHeart(let universityId):
                    self.showAlert = true
                    self.alertMessage = "관심대학으로 등록되었습니다."
                    universityIdToScroll = universityId
                case .removeHeart(let universityId):
                    self.showAlert = true
                    self.alertMessage = "관심대학이 삭제되었습니다."
                    universityIdToScroll = universityId
                }
            }
        }
    }
    
    var list: some View {
        ScrollView(.vertical) {
            ScrollViewReader { proxy in
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(viewModel.summaryArray, id: \.universityId) { cell in
                        if let id = cell.universityId, let image = cell.logo, let title = cell.fullName, let heartNum = cell.starNum, let starred = cell.starred {
                            HStack(spacing: 20) {
                                ListViewCell(model: SummaryModel(universityId: id, fullName: title, logo: image, starNum: heartNum, starred: starred), listViewModel: self.viewModel)
                            }
                            .tag(cell.universityId)
                        }
                    }
                }
                .task {
                    if universityIdToScroll != nil {
                        withAnimation {
                            proxy.scrollTo(universityIdToScroll, anchor: .center)
                        }
                        universityIdToScroll = nil
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
            }
        }
        .padding(.horizontal, 0)
        .padding(.bottom, 0)
        .refreshable {
            viewModel.send(action: .load)
            self.viewModel.searchText = ""
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
