//
//  ProfileView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/5/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("윤방구")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                    Text("강일여자고등학교")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)
                    Text("게시글 1개 • 쌓인 쪽지 7개")
                        .foregroundColor(.gray)
                        .font(.system(size: 15, weight: .semibold))
                }
                
                Spacer()
                
                Image("jack")
                    .resizable()
                    .scaledToFill()
                    .background(.gray)
                    .clipShape(.circle)
                    .frame(width: 100, height: 100)
                    .overlay(alignment: .bottomLeading) {
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(.black)
                            .frame(width: 30, height: 30)
                    }
            }
        }
    }
}

#Preview {
    ProfileView()
}
