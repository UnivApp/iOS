//
//  HeartView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/4/24.
//

import SwiftUI

struct HeartView: View {
    @StateObject var viewModel: HeartViewModel
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
                list
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("logo")
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
    static let authViewModel = AuthViewModel(container: .init(services: StubServices()))
    static var previews: some View {
        HeartView(viewModel: HeartViewModel(container: self.container))
            .environmentObject(Self.authViewModel)
            .environmentObject(Self.container)
    }
}
