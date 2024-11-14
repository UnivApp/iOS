//
//  CustomPageControl.swift
//  UnivApp
//
//  Created by 정성윤 on 9/28/24.
//

import SwiftUI

struct CustomPageControl: View {
    @Binding var currentPage: Int
    var numberOfPages: Int
    var body: some View {
        Button {
            //TODO: - NavigationLink
        } label: {
            Group {
                Text(" \(currentPage + 1) ")
                    .foregroundColor(.white)
                +
                Text("/ \(numberOfPages) ")
                    .foregroundColor(.borderGray)
            }
            .font(.system(size: 12, weight: .bold))
            .frame(width: 12 * 4, height: 20)
            .background(.black.opacity(0.5))
        }
    }
}

struct CustomPage_Previews: PreviewProvider{
    static var previews: some View {
        @State var currentPage: Int = 0
        CustomPageControl(currentPage: $currentPage, numberOfPages: 5)
    }
}
