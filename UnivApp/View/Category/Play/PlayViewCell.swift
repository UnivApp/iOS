//
//  PlayViewCell.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import SwiftUI

struct PlayViewCell: View {
    var title: String
    var address: String
    var description: String
    var image: String
    
    var body: some View {
        cell
    }
    
    var cell: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 20) {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .padding(.leading, 10)
                    .frame(width: 80, height: 80)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                    Text(address)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.gray)
                }
            }
            Divider()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    PlayViewCell(title: "세종대", address: "광진구 동일로", description: .init(), image: "emptyLogo")
}
