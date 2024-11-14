//
//  UnivAppApp.swift
//  UnivApp
//
//  Created by 정성윤 on 8/22/24.
//

import SwiftUI
import FirebaseCore
import AppTrackingTransparency
import SwiftKeychainWrapper

@main
struct UnivAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject var container: DIContainer = .init(services: Services())
    @ObservedObject var authViewModel: AuthViewModel = .init(container: .init(services: Services()), authState: .unAuth)
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(container)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        requestTrackingPermission()
                    }
                }
        }
    }
    private func requestTrackingPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("Tracking Authorized")
                case .denied, .restricted, .notDetermined:
                    print("Tracking Denied/Restricted/Not Determined")
                @unknown default:
                    print("Unknown status")
                }
            }
        }
    }
}
