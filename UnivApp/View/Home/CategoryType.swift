//
//  CategoryType.swift
//  UnivApp
//
//  Created by 정성윤 on 8/23/24.
//

import Foundation
import SwiftUI

enum CategoryType: String, CaseIterable {
    case event
    case food
    case graduate
    case info
    case initiative
    case money
    case mou
    case play
    
    var title: String {
        switch self {
        case .event:
            return "행사"
        case .food:
            return "맛집"
        case .graduate:
            return "졸업"
        case .info:
            return "정보"
        case .initiative:
            return "입결"
        case .money:
            return "월세"
        case .mou:
            return "협약"
        case .play:
            return "놀거리"
        }
    }
    
    var view: AnyView {
        switch self {
        case .event:
            return AnyView(EmptyView())
        case .food:
            return AnyView(EmptyView())
        case .graduate:
            return AnyView(EmptyView())
        case .info:
            return AnyView(EmptyView())
        case .initiative:
            return AnyView(EmptyView())
        case .money:
            return AnyView(EmptyView())
        case .mou:
            return AnyView(EmptyView())
        case .play:
            return AnyView(EmptyView())
        }
    }
    
    func imageName() -> String {
        return rawValue
    }

}
