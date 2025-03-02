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
    case list
    case todo
    case profile

    var sfSymbol: String {
        switch self {
        case .home:
            return "house.fill"
        case .calendar:
            return "calendar"
        case .list:
            return "list.bullet"
        case .todo:
            return "checklist"
        case .profile:
            return "person.fill"
        }
    }
}

