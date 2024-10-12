//
//  InitiativeViewCell.swift
//  UnivApp
//
//  Created by 정성윤 on 9/15/24.
//

import SwiftUI
import Kingfisher

struct InitiativeViewCell: View {
    var model: InitiativeModel
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(spacing: 40) {
                if let rankingResponses = model.universityRankingResponses.first {
                    Text("\(rankingResponses.rank) 위")
                        .font(.system(size: 15, weight: .heavy))
                        .foregroundColor(Color.blue)
                    
                    Group {
                        if let image = rankingResponses.logo {
                            KFImage(URL(string: image))
                                .resizable()
                                .scaledToFit()
                        } else {
                            Image("no_image")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    .frame(width: 45, height: 45)
                    
                    Text(rankingResponses.universityName)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 10)
    }
}

#Preview {
    InitiativeViewCell(model: InitiativeModel(displayName: "", fullName: "", description: "", year: "", category: "", universityRankingResponses: [UniversityRankingResponses(universityName: "", logo: "", rank: 1)]))
}
