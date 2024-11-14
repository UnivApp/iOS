//
//  PlaySegmentType.swift
//  UnivApp
//
//  Created by 정성윤 on 9/24/24.
//

import Foundation

enum PlaySegmentType: String, CaseIterable, Hashable {
    case hotplace
    case schoolList
    
    var title: String {
        switch self {
        case .hotplace:
            return "핫플"
        case .schoolList:
            return "학교"
        }
    }
}
