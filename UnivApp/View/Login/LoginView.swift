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
            
            VStack(alignment: .leading, spacing: 10) {
                Spacer()
                SignInWithAppleButton { request in
                    authViewModel.send(action: .appleLogin(request))
                } onCompletion: { result in
                    authViewModel.send(action: .appleLoginCompletion(result))
                }
                .frame(width: UIScreen.main.bounds.width - 60, height: 50)
                .overlay(alignment: .topLeading) {
                    Text("가입하고 더 많은 \n기능을 사용해 보세요!")
                        .foregroundColor(.primary)
                        .font(.system(size: 11, weight: .regular))
                        .multilineTextAlignment(.leading)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 15).fill(.white))
                        .padding(.top, -60)
                        .padding(.leading, -20)
                        .overlay(alignment: .bottomTrailing) {
                            Text("▼")
                                .rotationEffect(.degrees(-20))
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                }
                
                Button {
                    authViewModel.send(action: .nonMemberLogin)
                } label: {
                    Text("비회원으로 시작하기")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .frame(width: UIScreen.main.bounds.width - 60, height: 50)
                .background(.gray.opacity(0.8))
                .cornerRadius(5)
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
