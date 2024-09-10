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
    case info
    case logout
    case withdraw

    var title: String {
        switch self {
        case .version:
            return "버전정보"
        case .info:
            return "개인정보처리방침"
        case .logout:
            return "로그아웃"
        case .withdraw:
            return "회원탈퇴"
        }
    }
    
    var view: AnyView {
        switch self {
        case .version:
            return AnyView(VersionView())
        case .info:
            return AnyView(PolicyView())
        case .logout:
            return AnyView(LogoutView())
        case .withdraw:
            return AnyView(WithdrawView())
        }
    }
}

enum SupportType: CaseIterable {
    case feedback
    
    var title: String {
        switch self {
        case .feedback:
            return "피드백 보내기"
        }
    }
    
    var view: AnyView {
        switch self {
        case .feedback:
            return AnyView(WebKitView(url: ""))
        }
    }
}
