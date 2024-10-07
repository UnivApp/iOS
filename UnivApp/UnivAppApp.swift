//
//  UnivAppApp.swift
//  UnivApp
//
//  Created by 정성윤 on 8/22/24.
//

import SwiftUI
import SwiftKeychainWrapper

@main
struct UnivAppApp: App {
    @ObservedObject var container: DIContainer = .init(services: Services())
    @ObservedObject var authViewModel: AuthViewModel = .init(container: .init(services: Services()), authState: .unAuth)
    init() {
        if UserDefaults.standard.string(forKey: "FirstUser") == nil {
            UserDefaults.standard.set("true", forKey: "FirstUser")
            authViewModel.authState = .unAuth
        } else {
            UserDefaults.standard.set("false", forKey: "FirstUser")
            authViewModel.authState = .auth
        }
    }
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(container)
        }
    }
}
