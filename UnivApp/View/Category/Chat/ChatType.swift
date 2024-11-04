//
//  Chattype.swift
//  UnivApp
//
//  Created by 정성윤 on 10/21/24.
//
import Foundation
import Combine
import SwiftUI

enum ChatType: String, CaseIterable {
    case news
    case ranking
    case rent
    case employment
    case mou
    case food
    case hotplace
    case ontime
    case Occasion
    
    var title: String {
        switch self {
        case .food:
            return "맛집🍲"
        case .news:
            return "대입기사📰"
        case .ranking:
            return "랭킹🥇"
        case .rent:
            return  "월세🧧"
        case .mou:
            return "대학연계🎓"
        case .hotplace:
            return "핫플🌄"
        case .employment:
            return "취업률💼"
        case .ontime:
            return "정시경쟁률"
        case .Occasion:
            return "수시 경쟁률"
        }
    }
    
    var view: AnyView {
        switch self {
        case .food:
            return AnyView(FoodView(viewModel: FoodViewModel(container: .init(services: Services())), listViewModel: ListViewModel(container: .init(services: Services()), searchText: .init())))
        case .news:
            return AnyView(InfoView(viewModel: InfoViewModel(container: .init(services: Services()))))
        case .ranking:
            return AnyView(InitiativeView(viewModel: InitiativeViewModel(container: .init(services: Services()))))
        case .rent:
            return AnyView(MoneyView(listViewModel: ListViewModel(container: .init(services: Services()), searchText: .init()), viewModel: MoneyViewModel(container: .init(services: Services()))))
        case .mou:
            return AnyView(MouView(viewModel: MouViewModel(container: .init(services: Services()))))
        case .hotplace:
            return AnyView(PlayView(viewModel: PlayViewModel(container: .init(services: Services()))))
        case .Occasion:
            return AnyView(RateDetailView(viewModel: RateDetailViewModel(container: .init(services: Services())), listViewModel: ListViewModel(container: .init(services: Services()), searchText: .init())))
        case .employment:
            return AnyView(RateDetailView(viewModel: RateDetailViewModel(container: .init(services: Services())), listViewModel: ListViewModel(container: .init(services: Services()), searchText: .init())))
        case .ontime:
            return AnyView(RateDetailView(viewModel: RateDetailViewModel(container: .init(services: Services())), listViewModel: ListViewModel(container: .init(services: Services()), searchText: .init())))
        }
    }
}
