//
//  Color+Extension.swift
//  UnivApp
//
//  Created by 정성윤 on 8/22/24.
//

import Foundation
import SwiftUI

extension Color {
    static let backgroundColor = Color(UIColor.systemGray6.withAlphaComponent(0.3))
    static let customBlue = Color(UIColor.systemBlue.withAlphaComponent(0.1))
    static let customRed = Color(UIColor.systemRed.withAlphaComponent(0.1))
    
    //TODO: 지정색으로!
    static func random() -> Color {
        let colors: [Color] = [.blue, .green, .yellow, .orange, .purple, .pink]
        return colors.randomElement() ?? .blue
    }
    
}
