//
//  HomeFooterView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/17/25.
//

import SwiftUI

struct HomeFooterView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            HStack {
                Text("인기🔥 게시판")
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
            
            boardView
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }
    
    var boardView: some View {
        VStack(alignment: .center, spacing: 12) {
            ForEach(0...2, id: \.self) { _ in
                BoardSectionView()
            }
        }
    }
}

#Preview {
    HomeFooterView()
        .environmentObject(HomeViewModel())
}
