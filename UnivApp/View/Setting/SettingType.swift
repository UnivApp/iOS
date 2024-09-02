//
//  SettingType.swift
//  UnivApp
//
//  Created by 정성윤 on 8/24/24.
//

import Foundation

enum SettingType: CaseIterable {
    case heart
    case change
    case logout

    var title: String {
        switch self {
        case .heart:
            return "관심 학교"
        case .change:
            return "계정 정보 변경"
        case .logout:
            return "로그아웃"
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
    
}
