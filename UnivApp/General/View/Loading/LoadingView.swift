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
    var size: [CGFloat]
    var body: some View {
        if let url = Bundle.main.url(forResource: self.url, withExtension: "gif") {
            KFAnimatedImage(url)
                .frame(width: size[0], height: size[1])
                .scaledToFit()
                .background(.clear)
        }
    }
}

#Preview {
    LoadingView(url: "", size: [150, 150])
}
