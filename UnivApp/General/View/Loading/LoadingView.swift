//
//  LoadingView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/5/24.
//

import SwiftUI
import Kingfisher

struct LoadingView: View {
    var url: String
    var body: some View {
        if let url = Bundle.main.url(forResource: self.url, withExtension: "gif") {
            KFAnimatedImage(url)
                .frame(width: 150, height: 150)
                .scaledToFit()
                .background(.clear)
        }
    }
}

#Preview {
    LoadingView(url: "")
}
