//
//  CustomNavigationBar.swift
//  UnivApp
//
//  Created by 정성윤 on 9/22/24.
//

import SwiftUI

struct CustomNavigationBar: View {
    var body: some View {
        HStack {
            Image("back")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .background(.clear)
    }
}

#Preview {
    CustomNavigationBar()
}
