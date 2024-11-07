//
//  CategoryType.swift
//  UnivApp
//
//  Created by 정성윤 on 8/23/24.
//

import Foundation
import SwiftUI

enum CategoryType: String, CaseIterable {
    case festival
    case food
    case Diagnosis
    case info
    case initiative
    case money
    case mou
    case play
    
    var title: String {
        switch self {
        case .festival:
            return "축제"
        case .food:
            return "맛집"
        case .Diagnosis:
            return "학과매칭"
        case .info:
            return "대입기사"
        case .initiative:
            return "랭킹"
        case .money:
            return "월세"
        case .mou:
            return "대학연계"
        case .play:
            return "핫플"
        }
    }
    
    var view: AnyView {
        switch self {
        case .festival:
            return AnyView(FestivalView(viewModel: .init(container: .init(services: Services()))))
        case .food:
            return AnyView(FoodView(viewModel: FoodViewModel(container: .init(services: Services())), listViewModel: ListViewModel(container: .init(services: Services()), searchText: .init())))
        case .Diagnosis:
            return AnyView(DiagnosisView(viewModel: DiagnosisViewModel(container: .init(services: Services()))))
        case .info:
            return AnyView(InfoView(viewModel: InfoViewModel(container: .init(services: Services()))))
        case .initiative:
            return AnyView(InitiativeView(viewModel: InitiativeViewModel(container: .init(services: Services()))))
        case .money:
            return AnyView(MoneyView(listViewModel: ListViewModel(container: .init(services: Services()), searchText: .init()), viewModel: MoneyViewModel(container: .init(services: Services()))))
        case .mou:
            return AnyView(MouView(viewModel: MouViewModel(container: .init(services: Services()))))
        case .play:
            return AnyView(PlayView(viewModel: PlayViewModel(container: .init(services: Services()))))
        }
    }
    
    func imageName() -> String {
        return rawValue
    }

}
