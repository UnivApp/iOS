//
//  LoadingModifier.swift
//  UnivApp
//
//  Created by 정성윤 on 9/5/24.
//

import Foundation
import Kingfisher
import SwiftUI

struct LoadingModifier: ViewModifier {
    var url: String
    var size: [CGFloat]
    @Binding var isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                LoadingView(url: url, size: size)
                    .background(.clear)
            } else {
                LoadingView(url: "Empty", size: [0,0])
                    .background(.clear)
            }
        }
    }
}
