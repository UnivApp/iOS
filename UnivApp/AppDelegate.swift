//
//  AppDelegate.swift
//  UnivApp
//
//  Created by 정성윤 on 10/28/24.
//

import Foundation
import FirebaseMessaging
import FirebaseCore
import UIKit
import SwiftKeychainWrapper

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        application.registerForRemoteNotifications()
        requestNotificationAuthorization()
        
        FirebaseApp.configure()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("FCM 토큰 조회 실패 \(error)")
            } else if let token = token {
                print("FCM 토큰")
                KeychainWrapper.standard.remove(forKey: "DeviceToken")
                KeychainWrapper.standard.set(token, forKey: "DeviceToken")
            }
        }
    }
    
    private func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("알림 권한 요청 실패: \(error.localizedDescription)")
            } else {
                print("알림 권한 요청 결과: \(granted ? "허용됨" : "거부됨")")
            }
        }
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

