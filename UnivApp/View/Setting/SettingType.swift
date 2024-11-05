//
//  SettingType.swift
//  UnivApp
//
//  Created by 정성윤 on 8/24/24.
//

import Foundation
import SwiftUI

enum SettingType: CaseIterable {
    case version
    case logout
    case withdraw
    case feedback

    var title: String {
        switch self {
        case .version:
            return "버전 정보"
        case .logout:
            return "로그아웃"
        case .withdraw:
            return "회원 탈퇴"
        case .feedback:
            return "피드백 보내기"
        }
    }
    
    var view: AnyView {
        switch self {
        case .version:
            return AnyView(VersionView())
        case .logout:
            return AnyView(LogoutView())
        case .withdraw:
            return AnyView(WithdrawView())
        case .feedback:
            return AnyView(WebKitViewContainer(url: "https://forms.gle/Dq5bFQvGS1h6SJ9H9"))
        }
    }
    
    var image: String {
        switch self {
        case .version:
            return "ℹ️"
        case .logout:
            return "🔐"
        case .withdraw:
            return "🗑️"
        case .feedback:
            return "📨"
        }
    }
}
