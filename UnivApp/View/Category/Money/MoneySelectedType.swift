//
//  MoneySelectedType.swift
//  UnivApp
//
//  Created by 정성윤 on 10/19/24.
//

import Foundation

enum MoneySelectedType: String, CaseIterable {
    case officeTel
    case Coalition
    case Single
    case Apt
    
    var title: String {
        switch self {
        case .officeTel:
            return "오피스텔"
        case .Coalition:
            return "연립다세대"
        case .Single:
            return "단독다가구"
        case .Apt:
            return "아파트"
        }
    }
}
