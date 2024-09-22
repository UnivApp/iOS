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
    @State private var isActive: Bool = false
    
    var body: some View {
        NavigationStack {
            if isActive {
                AuthView(authViewModel: .init(container: container))
                    .environmentObject(container)
            } else {
                Image("splashScreen")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            isActive = true
                        }
                    }
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(DIContainer(services: StubServices()))
}
