//
//  HeartView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/4/24.
//

import SwiftUI

struct HeartView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: HeartViewModel
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        contentView
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
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        NavigationStack {
            VStack {
                if let memberState = (UserDefaults.standard.value(forKey: "nonMember")) {
                    if memberState as! String == "false" {
                        list
                    } else {
                        Text("로그인 후 관심대학 설정이 가능합니다!")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                } else {
                    ErrorView()
                        .onAppear {
                            authViewModel.authState = .unAuth
                            authViewModel.refreshTokenState = .Expired
                        }
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
    
    var list: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(viewModel.heartList, id: \.universityId) { cell in
                    if let id = cell.universityId, let image = cell.logo, let title = cell.fullName, let heartNum = cell.starNum, let starred = cell.starred {
                        HStack(spacing: 20) {
                            HeartViewCell(model: SummaryModel(universityId: id, fullName: title, logo: image, starNum: heartNum, starred: starred), heartViewModel: self.viewModel)
                                .tag(cell.universityId)
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

struct HeartView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices())
    static let authViewModel = AuthViewModel(container: .init(services: StubServices()), authState: .auth)
    static var previews: some View {
        HeartView(viewModel: HeartViewModel(container: self.container))
            .environmentObject(authViewModel)
    }
}
