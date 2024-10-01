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
                MainTabView()
                    .environmentObject(container)
                    .environmentObject(authViewModel)
//                LoginView()
//                    .environmentObject(authViewModel)
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
    AuthView(authViewModel: .init(container: .init(services: StubServices())))
        .environmentObject(DIContainer(services: StubServices()))
}
