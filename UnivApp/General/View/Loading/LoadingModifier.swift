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
    @Binding var isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                LoadingView(url: url)
                    .background(.clear)
            } else {
                LoadingView(url: "Empty")
                    .background(.clear)
            }
        }
    }
}
