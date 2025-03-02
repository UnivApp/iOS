//
//  BoardSectionView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/2/25.
//

import SwiftUI

struct BoardSectionView: View {
    //TODO: Value
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Spacer()
            HStack {
                Label {
                    Text("익명")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.gray)
                } icon: {
                    Image(systemName: "person.circle.fill")
                        .tint(.gray.opacity(0.7))
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                Spacer()
                Text("02/17 03:12")
                    .foregroundColor(.gray)
                    .font(.system(size: 12, weight: .regular))
            }
            .padding(.horizontal, 12)
            
            Group {
                Text("🚨비상이야 얘들아🚨")
                    .foregroundColor(.black)
                    .font(.system(size: 15, weight: .bold))
                
                Text("진짜 자기 싫다...그치만 졸리다...낼 등교...")
                    .foregroundColor(.black)
                    .font(.system(size: 13, weight: .regular))
                    .lineLimit(1)
            }
            .padding(.horizontal, 12)
            
            HStack(spacing: 8) {
                Text("자유게시판")
                    .foregroundColor(.gray)
                    .font(.system(size: 13, weight: .regular))
                
                Spacer()
                
                Label {
                    Text("26")
                        .font(.system(size: 12, weight: .regular))
                } icon: {
                    Image(systemName: "heart.fill")
                        .frame(width: 20, height: 20)
                        .scaledToFit()
                }
                .tint(.red.opacity(0.8))
                .foregroundColor(.red.opacity(0.8))
                
                
                Label {
                    Text("26")
                        .font(.system(size: 12, weight: .regular))
                } icon: {
                    Image(systemName: "bubble.fill")
                        .frame(width: 20, height: 20)
                        .scaledToFit()
                }
                .tint(.blue.opacity(0.8))
                .foregroundColor(.blue.opacity(0.8))
            }
            .padding(.horizontal, 12)
            Spacer()
        }
        .background(.white)
        .clipped()
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 0)
    }
}

#Preview {
    BoardSectionView()
}
