//
//  MainTabType.swift
//  UnivApp
//
//  Created by 정성윤 on 8/23/24.
//

import Foundation

enum MainTabType: String, CaseIterable {
    case home
    case calendar
    case list
    case todo
    case profile
    
    func imageName(selected: Bool) -> String {
        selected ? "\(rawValue)_fill" : rawValue
    }
}
