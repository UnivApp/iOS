//
//  SettingProfileView.swift
//  UnivApp
//
//  Created by 정성윤 on 1/8/25.
//

import SwiftUI

struct SettingProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: SettingViewModel
    
    @Binding var isPresented: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 40) {
            Image("smile")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .padding(10)
                .background(Circle().fill(.white).shadow(radius: 1))
            
            if let memberState = (UserDefaults.standard.value(forKey: "nonMember")) {
                if memberState as! String == "false" {
                    Group {
                        Text("  \(viewModel.userNickname)")
                            .foregroundColor(.orange)
                            .font(.system(size: 20, weight: .heavy))
                        +
                        Text("님\n 환영합니다!")
                            .foregroundColor(.black)
                            .font(.system(size: 20, weight: .semibold))
                    }
                    .multilineTextAlignment(.leading)
                    .padding(.top, 10)
                    .overlay(alignment: .topLeading) {
                        Button {
                            isPresented = true
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.blue.opacity(0.7))
                                .padding(.top, -5)
                                .padding(.leading, -10)
                        }
                    }
                } else {
                    Button {
                        authViewModel.authState = .unAuth
                    } label: {
                        VStack(alignment: .leading) {
                            Text("로그인 및 회원가입하기 ▷")
                                .foregroundColor(.orange)
                                .font(.system(size: 14, weight: .semibold))
                            
                            Text("가입하고 더 많은 기능을 사용해 보세요!")
                                .foregroundColor(.gray)
                                .font(.system(size: 11, weight: .regular))
                        }
                        .multilineTextAlignment(.leading)
                    }
                }
            } else {
                ErrorView()
                    .onAppear {
                        authViewModel.authState = .unAuth
                        authViewModel.refreshTokenState = .Expired
                    }
            }
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 30)
    }
}

//#Preview {
//    SettingProfileView()
//}
