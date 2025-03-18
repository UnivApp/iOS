//
//  HomeViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 3/17/25.
//

import SwiftUI
import Combine

enum HomeCategoryType: String, CaseIterable {
    case school = "학교 사이트"
    case meal = "급식"
    case schedule = "학사 일정"
    case list = "게시판"
    case university = "대학 정보"
    
    var image: String {
        switch self {
        case .school:
            return "building.columns"
        case .meal:
            return "fork.knife"
        case .schedule:
            return "calendar"
        case .list:
            return "list.dash"
        case .university:
            return "graduationcap"
        }
    }
    
    var view: AnyView {
        switch self {
        case .meal:
            return AnyView(MealListView(viewModel: MealListViewModel()))
        default:
            return AnyView(EmptyView())
        }
    }
}

final class HomeViewModel: ObservableObject {
    
    enum Action {
        
    }
    
    @Published var phase: Phase = .notRequested
    private var subscriptions = Set<AnyCancellable>()
    
    func sendAction(_ action: Action) {
        
    }
    
}
