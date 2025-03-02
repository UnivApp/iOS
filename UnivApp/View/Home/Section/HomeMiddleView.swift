//
//  HomeMiddleView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/2/25.
//

import SwiftUI

struct HomeMiddleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Group {
                HStack {
                    Text("게시판👀")
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 20, weight: .bold))
                    
                    Spacer()
                    
                    Button {
                        //TODO: 더보기
                    } label: {
                        Text("더보기 ▶︎")
                            .foregroundColor(.gray)
                            .font(.system(size: 15, weight: .semibold))
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Spacer()
                    ForEach(0...4, id: \.self) { tab in
                        HStack {
                            Text("@@게시판")
                                .foregroundColor(.black.opacity(0.7))
                                .font(.system(size: 15, weight: .semibold))
                            
                            Text("내일 학교 안하겠지?")
                                .foregroundColor(.gray)
                                .font(.system(size: 15, weight: .regular))
                            Spacer()
                        }
                        .padding(.horizontal, 12)
                    }
                    Spacer()
                }
                .background(.white)
                .clipped()
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 0)
            }
            
            Group {
                HStack {
                    Text("HOT🔥 게시판")
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 20, weight: .bold))
                    
                    Spacer()
                    
                    Button {
                        //TODO: 더보기
                    } label: {
                        Text("더보기 ▶︎")
                            .foregroundColor(.gray)
                            .font(.system(size: 15, weight: .semibold))
                    }
                }
                
                ForEach(0...2, id: \.self) { _ in
                    VStack(spacing: 12) {
                        BoardSectionView()
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}


#Preview {
    HomeMiddleView()
}
