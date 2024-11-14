//
//  LoginView.swift
//  UnivApp
//
//  Created by 정성윤 on 8/22/24.
//

import SwiftUI
import Combine
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var container: DIContainer
    
    
    var body: some View {
        contentView
            .navigationBarBackButtonHidden(true)
    }
    
    var contentView: some View {
        ZStack {
            Image("loginScreen")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                Button {
                    authViewModel.send(action: .nonMemberLogin)
                } label: {
                    Text("비회원으로 시작하기")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                }

                SignInWithAppleButton { request in
                    authViewModel.send(action: .appleLogin(request))
                } onCompletion: { result in
                    authViewModel.send(action: .appleLoginCompletion(result))
                }
                .frame(height: 50)
            }
            .padding(.bottom, 40)
            .padding(.horizontal, 30)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LoginView()
}
