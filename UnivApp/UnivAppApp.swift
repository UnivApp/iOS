//
//  UnivAppApp.swift
//  UnivApp
//
//  Created by 정성윤 on 8/22/24.
//

import SwiftUI

@main
struct UnivAppApp: App {
    @StateObject var container: DIContainer = .init(services: Services(authService: AuthService()))
    var body: some Scene {
        WindowGroup {
            AuthView(authViewModel: .init(container: container))
                .environmentObject(container)
        }
    }
}
