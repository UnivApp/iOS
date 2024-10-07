//
//  AuthView.swift
//  UnivApp
//
//  Created by 정성윤 on 8/22/24.
//

import SwiftUI

@MainActor
struct AuthView: View {
    @EnvironmentObject var container: DIContainer
    @StateObject var authViewModel: AuthViewModel
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            switch authViewModel.authState {
            case .unAuth:
                switch authViewModel.refreshTokenState {
                case .unExpired:
                    LoginView()
                        .environmentObject(authViewModel)
                case .Expired:
                    LoginView()
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("로그인 만료 ⚠️"), message: Text("세션이 만료되어 재로그인이 필요합니다."), dismissButton: .default(Text("확인")))
                        }
                        .onAppear { self.showAlert = true }
                        .environmentObject(authViewModel)
                }
            case .auth:
                MainTabView()
                    .environmentObject(container)
                    .environmentObject(authViewModel)
            }
        }
        .onAppear {
            authViewModel.send(action: .checkAuthState)
        }
    }
}

#Preview {
    AuthView(authViewModel: .init(container: .init(services: StubServices()), authState: .auth))
        .environmentObject(DIContainer(services: StubServices()))
}
