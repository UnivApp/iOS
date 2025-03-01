//
//  SplitType.swift
//  UnivApp
//
//  Created by 정성윤 on 9/15/24.
//

import Foundation
import SwiftUI

enum SplitType: String, CaseIterable{
    case employment
    case ontime
    case Occasion
    
    var title: String {
        switch self {
        case .employment:
            return "취업률"
        case .ontime:
            return "정시 경쟁률"
        case .Occasion:
            return "수시 경쟁률"
        }
    }
}
