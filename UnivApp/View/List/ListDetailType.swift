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
    case graduate
    case food
    case event
    
    var title: String {
        switch self {
        case .play:
            return "핫플"
        case .mou:
            return "협약"
        case .money:
            return "평균월세"
        case .initiative:
            return "순위"
        case .info:
            return "기사"
        case .graduate:
            return "졸업자"
        case .food:
            return "맛집"
        case .event:
            return "행사"
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
        case .graduate:
            return Image("graduate")
        case .food:
            return Image("food")
        case .event:
            return Image("event")
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
        case .graduate:
            return "해당 대학의 졸업자를 확인해 보세요!"
        case .food:
            return "대학 주변의 맛집을 확인해 보세요!"
        case .event:
            return "대학의 행사들을 확인해 보세요!"
        }
    }
}
