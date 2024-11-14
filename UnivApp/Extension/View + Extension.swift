//
//  View + Extension.swift
//  UnivApp
//
//  Created by 정성윤 on 9/5/24.
//

import Foundation
import SwiftUI

extension View {
    func fadeInOut(_ isVisible: Binding<Bool>, duration: Double = 0.3) -> some View {
        self
            .opacity(isVisible.wrappedValue ? 1 : 0)
            .onAppear {
                withAnimation(.easeInOut(duration: duration)) {
                    isVisible.wrappedValue = true
                }
                
            }
            .onDisappear {
                withAnimation(.easeInOut(duration: duration)) {
                    isVisible.wrappedValue = false
                }
            }
    }
}
