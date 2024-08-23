//
//  MainTabType.swift
//  UnivApp
//
//  Created by 정성윤 on 8/23/24.
//

import Foundation

enum MainTabType: String, CaseIterable {
    case home
    case list
    case heart
    case setting
    
    var title: String {
        switch self {
        case .home:
            return "홈"
        case .list:
            return "리스트"
        case .heart:
            return "관심대학"
        case .setting:
            return "설정"
        }
    }
    
    func imageName(selected: Bool) -> String {
        selected ? "\(rawValue)_fill" : rawValue
    }
}
