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
    
    //TODO: 지정색으로!
    static func random() -> Color {
        let colors: [Color] = [.blue, .green, .yellow, .orange, .purple, .pink]
        return colors.randomElement() ?? .blue
    }
    
}
