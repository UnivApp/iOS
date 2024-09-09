//
//  ErrorView.swift
//  MessengerApp
//
//  Created by 정성윤 on 8/14/24.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            ZStack {
                LoadingView(url: "error")
                    .padding(.horizontal, 0)
            }
            .padding(.bottom, 10)
            
            Text("이궁..현재 접속이 원할하지 않아요..")
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.black)
            .padding(.bottom, 20)
            
            Group {
                Text("일시적인 오류로 서버와 연결이 끊겼습니다.")
                Text("잠시 후 다시 시도해 주세요.")
            }
            .font(.system(size: 13, weight: .regular))
            .foregroundColor(.black)
            
        }
        .padding(EdgeInsets())
    }
}

#Preview {
    ErrorView()
}
