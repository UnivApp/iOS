//
//  LoadingView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/17/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .foregroundColor(.gray)
        }
        .background(.white)
    }
}

#Preview {
    LoadingView()
}
