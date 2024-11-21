//
//  ListDetailType.swift
//  UnivApp
//
//  Created by 정성윤 on 9/5/24.
//

import Foundation
import SwiftUI

enum ListDetailType: String, CaseIterable {
    case play
    case mou
    case money
    case initiative
    case info
    case Diagnosis
    case food
    case festival
    
    var title: String {
        switch self {
        case .play:
            return "핫플"
        case .mou:
            return "대학연계"
        case .money:
            return "월세"
        case .initiative:
            return "랭킹"
        case .info:
            return "대입기사"
        case .Diagnosis:
            return "학과매칭"
        case .food:
            return "맛집"
        case .festival:
            return "축제"
        }
    }
    
    var image: Image {
        switch self {
        case .play:
            return Image("play")
        case .mou:
            return Image("mou")
        case .money:
            return Image("money")
        case .initiative:
            return Image("initiative")
        case .info:
            return Image("info")
        case .Diagnosis:
            return Image("Diagnosis")
        case .food:
            return Image("food")
        case .festival:
            return Image("festival")
        }
    }
    
    var description: String {
        switch self {
        case .play:
            return "대학 주변의 핫플을 확인해 보세요!"
        case .mou:
            return "대학과 협약한 곳을 확인해 보세요!"
        case .money:
            return "대학 주변의 평균 월세를 확인해 보세요!"
        case .initiative:
            return "대학의 순위를 확인해 보세요!"
        case .info:
            return "대학의 기사를 확인해 보세요!"
        case .Diagnosis:
            return "나에게 맞는 학과를 확인해 보세요!"
        case .food:
            return "대학 주변의 맛집을 확인해 보세요!"
        case .festival:
            return "대학 축제를 미리 즐겨보세요!"
        }
    }
    
    var view: AnyView {
        switch self {
        case .festival:
            return AnyView(FestivalView(viewModel: .init(container: .init(services: Services())), listViewModel: .init(container: .init(services: Services()), searchText: .init())))
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
}
