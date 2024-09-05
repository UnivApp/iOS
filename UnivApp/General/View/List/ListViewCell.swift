//
//  ListCellView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import SwiftUI

struct ListViewCell: View {
    var image: String
    var title: String
    var heartNum: String
    var destination: ListCellDestination?
    var heart: Bool
    
    var body: some View {
        cell
    }
    
    var cell: some View {
        VStack(alignment: .center) {
            Spacer()
            
            HStack {
                ZStack {
                    Image("love_empty")
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Image("love_fill")
                        .resizable()
                        .frame(width: 12, height: 12)
                }
                .padding(.leading, 20)
                Spacer()
            }
            
            Spacer()
            
            Image("emptyLogo")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 30)
            
            Spacer()
            
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black)
                .padding(.horizontal, 0)
            
            Spacer()
            
            HStack {
                Spacer()
                
                Text(heartNum)
                    .font(.system(size: 12))
                    .foregroundColor(.orange)
                    .padding(.trailing, 10)
                
                Image("star")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .padding(.trailing, 20)
            }
            
            Spacer()
            
            NavigationLink(destination: destination?.view) {
                Text("정보보기")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.orange)
            }
            .frame(height: 30)
            .padding(.horizontal, 30)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.orange, lineWidth: 1)
            )
            
            Spacer()
            
        }
        .frame(width: 150, height: 250)
        .border(.gray, width: 0.5)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.bordergroundGray, lineWidth: 1.0)
        )
    }
}

#Preview {
    ListViewCell(image: "", title: "", heartNum: "", heart: false)
}
