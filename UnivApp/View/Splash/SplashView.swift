//
//  SplashView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/22/24.
//

import SwiftUI
import Foundation

struct SplashView: View {
    @EnvironmentObject private var container: DIContainer
    @StateObject private var authViewModel = AuthViewModel(container: DIContainer(services: Services()), authState: .unAuth)
    @State private var isActive: Bool = false
    
    var body: some View {
        if isActive {
            AuthView(authViewModel: authViewModel)
                .environmentObject(container)
        } else {
            ZStack {
                LoadingView(url: "logo_Splash", size: [UIScreen.main.bounds.width - 150, UIScreen.main.bounds.width - 150])
                    .onAppear {
                        if UserDefaults.standard.string(forKey: "FirstUser") == nil {
                            UserDefaults.standard.set("true", forKey: "FirstUser")
                            authViewModel.authState = .unAuth
                        } else {
                            UserDefaults.standard.set("false", forKey: "FirstUser")
                            authViewModel.authState = .auth
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            self.isActive = true
                        }
                    }
                    .padding(.horizontal, 0)
                    .padding(.vertical, 0)
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(DIContainer(services: StubServices()))
}
