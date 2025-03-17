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
    var body: some Scene {
        WindowGroup {
            //TODO: 로그인 판별
            TabBarView()
        }
    }
}
