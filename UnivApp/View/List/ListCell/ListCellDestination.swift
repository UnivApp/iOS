//
//  ListCellDestination.swift
//  UnivApp
//
//  Created by 정성윤 on 9/5/24.
//

import Foundation
import SwiftUI

enum ListCellDestination: CaseIterable {
    case list
    case event
    case food
    case graduate
    case info
    case initiative
    case money
    case mou
    case play
    
    var view: AnyView {
        switch self {
        case .list:
            return AnyView(ListDetailView(viewModel: ListDetailViewModel(container: DIContainer(services: Services(authService: AuthService())))))
        case .event:
            return AnyView(EventDetailView())
        case .food:
            return AnyView(FoodDetailView())
        case .graduate:
            return AnyView(GraduateDetailView())
        case .info:
            return AnyView(InfoDetailView())
        case .initiative:
            return AnyView(InitiativeDetailView())
        case .money:
            return AnyView(MoneyDetailView())
        case .mou:
            return AnyView(MouDetailView())
        case .play:
            return AnyView(PlayDetailView())
        }
    }
}
