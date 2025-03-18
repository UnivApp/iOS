//
//  BoardSectionView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/17/25.
//

import SwiftUI

struct BoardSectionView: View {
    //TODO: Model
    var body: some View {
        Group {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("🚨 비상이야 얘들아 🚨")
                        .lineLimit(1)
                        .foregroundColor(.primary)
                        .font(.system(size: 15, weight: .bold))
                    
                    Spacer()
                    
                    Text("24.02.17 03:12")
                        .foregroundColor(.gray)
                        .font(.system(size: 13, weight: .regular))
                }
                
                Text("낼 급식 뭐냐??? 배고프네")
                    .lineLimit(1)
                    .foregroundColor(.black)
                    .font(.system(size: 13, weight: .regular))
                
                HStack(alignment: .center) {
                    Text("비밀게시판")
                        .foregroundColor(.gray)
                        .font(.system(size: 13, weight: .regular))
                    
                    Spacer()
                    Group {
                        Label {
                            Text("26")
                                .font(.system(size: 12, weight: .regular))
                        } icon: {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                        }
                        .foregroundColor(.red)
                        
                        Label {
                            Text("35")
                                .font(.system(size: 12, weight: .regular))
                        } icon: {
                            Image(systemName: "bubble.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
            .padding(.all, 12)
        }
        .frame(height: 100)
        .background(.white)
        .cornerRadius(15)
        .clipped()
        .shadow(radius: 0.7)
    }
}

#Preview {
    BoardSectionView()
}
