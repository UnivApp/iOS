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
    
    var body: some View {
        VStack {
            switch authViewModel.authState {
            case .unAuth:
                LoginView(loginViewModel: LoginViewModel())
                    .environmentObject(authViewModel)
            case .auth:
                MainTabView()
                    .environmentObject(authViewModel)
            }
        }
        .onAppear {
            authViewModel.send(action: .checkAuthState)
//            authViewModel.send(action: .logout)
        }
    }
}

#Preview {
    AuthView(authViewModel: AuthViewModel(container: .init(services: Services())))
}
