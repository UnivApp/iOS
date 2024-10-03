//
//  UnivAppApp.swift
//  UnivApp
//
//  Created by 정성윤 on 8/22/24.
//

import SwiftUI

@main
struct UnivAppApp: App {
    @StateObject var container: DIContainer = .init(services: Services())
    @StateObject var authViewModel: AuthViewModel = .init(container: .init(services: Services()))
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(container)
        }
    }
}
