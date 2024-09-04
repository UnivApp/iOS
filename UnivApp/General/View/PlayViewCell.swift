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
        ZStack {
            Image("page")
                .resizable()
                .frame(height: 250)
                .scaledToFit()
                .shadow(radius: 5)
            
            VStack(alignment: .center) {
                Spacer()
                
                HStack(spacing: 20) {
                    Image("emptyLogo")
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
                    .padding(.trailing, 50)
                }
                .frame(height: 250)
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
                
                Spacer()
                
            }
        }
    }
}

#Preview {
    PlayViewCell(title: .init(), address: .init(), description: .init(), image: .init())
}
