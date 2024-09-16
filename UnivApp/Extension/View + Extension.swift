//
//  View + Extension.swift
//  UnivApp
//
//  Created by 정성윤 on 9/5/24.
//

import Foundation
import SwiftUI

extension View {
    
    func startLoading(url: String, isLoading: Binding<Bool>) -> some View {
        self.modifier(LoadingModifier(url: url, isLoading: isLoading))
    }
    
}
