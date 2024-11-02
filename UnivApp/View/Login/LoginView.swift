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
            
            VStack(alignment: .leading) {
                Spacer()
                SignInWithAppleButton { request in
                    authViewModel.send(action: .appleLogin(request))
                } onCompletion: { result in
                    authViewModel.send(action: .appleLoginCompletion(result))
                }
                .frame(height: 50)
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LoginView()
}
