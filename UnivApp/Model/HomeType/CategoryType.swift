//
//  CategoryType.swift
//  UnivApp
//
//  Created by 정성윤 on 8/23/24.
//

import Foundation
import SwiftUI

enum CategoryType: String, CaseIterable {
    case site
    case food
    case calendar
    case info
    
    var title: String {
        switch self {
        case .site:
            "학교 홈페이지"
        case .food:
            "급식"
        case .calendar:
            "학사 일정"
        case .info:
            "대학정보"
        }
    }
    
    var view: AnyView {
        return AnyView(EmptyView())
    }
    
    var imageName: String {
        switch self {
        case .site:
            "building.columns"
        case .food:
            "takeoutbag.and.cup.and.straw"
        case .calendar:
            "calendar.badge.exclamationmark"
        case .info:
            "graduationcap"
        }
    }

}
