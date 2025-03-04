//
//  MainTabType.swift
//  UnivApp
//
//  Created by 정성윤 on 8/23/24.
//

import Foundation

enum MainTabType: String, CaseIterable {
    case home
    case calendar
    case chat
    case todo
    case profile

    var sfSymbol: String {
        switch self {
        case .home:
            return "house.fill"
        case .calendar:
            return "calendar"
        case .chat:
            return "bubble"
        case .todo:
            return "checklist"
        case .profile:
            return "person.fill"
        }
    }
}

