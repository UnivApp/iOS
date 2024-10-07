//
//  LogoutView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/10/24.
//

import SwiftUI

struct LogoutView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State var isShow: Bool = false
    var body: some View {
        contentView
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
    }
    
    @ViewBuilder
    var contentView: some View {
        switch authViewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear {
                    authViewModel.send(action: .logout)
                }
        case .loading:
            LoadingView(url: "load", size: [150, 150])
        case .success:
            logoutUser
                .onAppear {
                    self.isShow = true
                }
        case .fail:
            ErrorView()
        }
    }
    
    var logoutUser: some View {
        LoadingView(url: "load", size: [150, 150])
        .alert(isPresented: $isShow) {
            Alert (
                title: Text("로그아웃 성공 🔓"),
                message: Text("어플을 사용하기 위해서는 사용자 로그인이 필요합니다."),
                dismissButton: .default(Text("확인"), action: {
                    self.authViewModel.authState = .unAuth
                    self.authViewModel.refreshTokenState = .unExpired
                })
            )
        }
    }
}

#Preview {
    LogoutView()
        .environmentObject(AuthViewModel(container: .init(services: StubServices()), authState: .auth))
}
