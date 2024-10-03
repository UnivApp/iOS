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
                        Image("blackback")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
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
            LoadingView(url: "load", size: [150, 150])
        case .success:
            expireUser
                .onAppear {
                    self.isShow = true
                }
        case .fail:
            ErrorView()
        }
    }
    
    var expireUser: some View {
        LoadingView(url: "load", size: [150, 150])
            .alert(isPresented: $isShow) {
                Alert (
                    title: Text("회원탈퇴 성공"),
                    message: Text("회원님의 데이터를 영구 삭제했습니다."),
                    dismissButton: .default(Text("확인"), action: {
                        self.authViewModel.authState = .unAuth
                        self.authViewModel.refreshTokenState = .unExpired
                    })
                )
            }
    }
}

#Preview {
    WithdrawView()
        .environmentObject(AuthViewModel(container: .init(services: StubServices())))
}
