//
//  FoodSegmentType.swift
//  UnivApp
//
//  Created by 정성윤 on 10/7/24.
//

import Foundation

enum FoodSegmentType: String, CaseIterable, Hashable {
    case hotPlace
    case schoolList
    
    var title: String {
        switch self {
        case .hotPlace:
            return "맛집"
        case .schoolList:
            return "학교"
        }
    }
}
