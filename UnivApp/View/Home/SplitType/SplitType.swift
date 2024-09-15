//
//  SplitType.swift
//  UnivApp
//
//  Created by 정성윤 on 9/15/24.
//

import Foundation
import SwiftUI

enum SplitType: String, CaseIterable{
    case competition
    case ontime
    case Occasion
    
    var title: String {
        switch self {
        case .competition:
            return "경쟁률"
        case .ontime:
            return "정시입결"
        case .Occasion:
            return "수시입결"
        }
    }
}
