//
//  HomeMiddleView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/17/25.
//

import SwiftUI

struct HomeMiddleView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Group {
                HStack {
                    Text("급식표🍚")
                        .foregroundColor(.primary)
                        .font(.system(size: 18, weight: .heavy))
                    
                    Spacer()
                    
                    Button {
                        //TODO: 더보기
                    } label: {
                        Text("더보기 ▶︎")
                            .foregroundColor(.gray)
                            .font(.system(size: 15, weight: .semibold))
                    }
                }
                .padding(.horizontal, 24)
                
                FoodSectionView()
                
                Group {
                    HStack {
                        Text("최신 게시글 👀")
                            .foregroundColor(.primary)
                            .font(.system(size: 18, weight: .heavy))
                        Spacer()
                    }
                    
                    RecentView()
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

fileprivate struct RecentView: View {
    //TODO: Model
    var body: some View {
        Group {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(0...5, id: \.self) { index in
                    HStack(alignment: .center, spacing: 24) {
                        Text("자유게시판")
                            .foregroundColor(.gray)
                            .font(.system(size: 13, weight: .semibold))
                        
                        Text("내일 학교 안 망하겠지?")
                            .lineLimit(1)
                            .foregroundColor(.gray)
                            .font(.system(size: 12, weight: .regular))
                        Spacer()
                    }
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
        }
        .frame(height: 170)
        .background(.white)
        .clipped()
        .cornerRadius(15)
        .shadow(radius: 0.7)
    }
}

#Preview {
    HomeMiddleView()
        .environmentObject(HomeViewModel())
}
