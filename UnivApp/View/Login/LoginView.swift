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
    @EnvironmentObject var container: DIContainer
    @StateObject var loginViewModel: LoginViewModel
    
    
    var body: some View {
        contentView
    }
    
    var contentView: some View {
        VStack(alignment: .leading) {
            Text("환영합니다")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.black)
                .padding(.bottom, 30)
                .padding(.top, 100)
                .padding(.horizontal, 30)
            
            Text("다양한 대학 정보를 확인해 보세요!")
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(.gray)
                .padding(.horizontal, 30)
            
            Spacer()
            
            SignInWithAppleButton { request in
                
            } onCompletion: { completion in

            }
            .frame(height: 60)
            .padding(.horizontal, 30)
            .padding(.bottom, 30)

        }
    }
}

#Preview {
    LoginView(loginViewModel: LoginViewModel())
}
