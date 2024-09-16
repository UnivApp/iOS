//
//  InitiativeViewCell.swift
//  UnivApp
//
//  Created by 정성윤 on 9/15/24.
//

import SwiftUI

struct InitiativeViewCell: View {
    var model: InitiativeModel
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                if let title = model.title,
                   let rank = model.rank,
                   let logo = model.logo,
                   let description = model.description{
                    Text("\(rank)")
                        .font(.system(size: 15, weight: .heavy))
                        .foregroundColor(Color.blue)
                    
                    Image(logo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(title)
                            .font(.system(size: 15, weight: .heavy))
                            .foregroundColor(Color.black)
                        
                        Text(description)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color.gray)
                    }
                    
                    //TODO: - 관심대학 등록
                    Image("heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 25)
                    
                }
            }
            Divider()
                .padding(.top, 10)
                .padding(.horizontal, 30)
        }
    }
}

#Preview {
    InitiativeViewCell(model: InitiativeModel(title: "세종대학교", logo: "emptyLogo", description: "소재: 서울 백분위(영어감점): 97.41 (0.2)", rank: 1))
}
