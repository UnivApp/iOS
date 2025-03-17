//
//  TabBarType.swift
//  UnivApp
//
//  Created by 정성윤 on 3/17/25.
//

import Foundation
import Combine

enum TabBarType: CaseIterable {
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
