//
//  ListView.swift
//  UnivApp
//
//  Created by 정성윤 on 8/23/24.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: ListViewModel
    @FocusState private var isFocused: Bool
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State var universityIdToScroll: Int? = nil
    
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
                .onAppear {
                    viewModel.searchText = ""
                }
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
                
                //TODO: - 서치 기능 수정
                ListSearchView(isFocused: self._isFocused)
                    .environmentObject(self.viewModel)
                
                Spacer()
                
                ZStack {
                    if viewModel.notFound == true {
                        Text("학교를 찾을 수 없습니다. 🧐")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.gray)
                    }
                    ListItemsVIew(universityIdToScroll: $universityIdToScroll)
                        .environmentObject(viewModel)
                        .environmentObject(authViewModel)
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
}

struct ListView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices())
    static let authViewModel = AuthViewModel(container: .init(services: StubServices()), authState: .auth)
    static var previews: some View {
        ListView(viewModel: ListViewModel(container: self.container, searchText: ""), universityIdToScroll: 0)
            .environmentObject(authViewModel)
    }
}
