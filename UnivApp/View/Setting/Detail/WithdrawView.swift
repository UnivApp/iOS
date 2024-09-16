//
//  WithdrawView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/10/24.
//

import SwiftUI

struct WithdrawView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var isShow: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        contentView
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("back")
                    }
                }
            }
    }
    
    @ViewBuilder
    var contentView: some View {
        switch authViewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear {
                    authViewModel.send(action: .withdraw)
                }
        case .loading:
            LoadingView(url: "load")
        case .success:
            expireUser
        case .fail:
            ErrorView()
        }
    }
    
    var expireUser: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 10) {
                LoadingView(url: "withdraw")
                
                Text("회원탈퇴 성공")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                
                Text("회원님의 데이터를 영구 삭제했습니다.")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    WithdrawView()
        .environmentObject(AuthViewModel(container: .init(services: StubServices())))
}
