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
            return "졸업자"
        case .info:
            return "정보"
        case .initiative:
            return "입결"
        case .money:
            return "월세"
        case .mou:
            return "협약"
        case .play:
            return "핫플"
        }
    }
    
    var view: AnyView {
        switch self {
        case .event:
            return AnyView(EventView(viewModel: EventViewModel(searchText: .init(), container: .init(services: Services(authService: AuthService())))))
        case .food:
            return AnyView(FoodView(viewModel: FoodViewModel(searchText: .init(), container: .init(services: Services(authService: AuthService())))))
        case .graduate:
            return AnyView(GraduateView(viewModel: GraduateViewModel(searchText: .init(), container: .init(services: Services(authService: AuthService())))))
        case .info:
            return AnyView(InfoView(viewModel: InfoViewModel(searchText: .init(), container: .init(services: Services(authService: AuthService())))))
        case .initiative:
            return AnyView(InitiativeView(viewModel: InitiativeViewModel(searchText: .init(), container: .init(services: Services(authService: AuthService())))))
        case .money:
            return AnyView(MoneyView(viewModel: MoneyViewModel(searchText: .init(), container: .init(services: Services(authService: AuthService())))))
        case .mou:
            return AnyView(MouView(viewModel: MouViewModel(searchText: .init(), container: .init(services: Services(authService: AuthService())))))
        case .play:
            return AnyView(PlayView(viewModel: PlayViewModel(container: .init(services: Services(authService: AuthService())), searchText: .init())))
        }
    }
    
    func imageName() -> String {
        return rawValue
    }

}
