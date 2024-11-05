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
    
    var description: String {
        switch self {
        case .version:
            return "버전 정보와 제공 기능을 확인해 보세요! 👀"
        case .logout:
            return "로그아웃으로 계정 관리를 해보세요 🛠️"
        case .withdraw:
            return "회원 탈퇴 시 기존의 모든 정보가 삭제돼요 😭"
        case .feedback:
            return "어플의 불편 사항을 보내주세요! 🤲🏻"
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
