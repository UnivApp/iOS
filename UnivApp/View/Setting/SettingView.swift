//
//  SettingView.swift
//  UnivApp
//
//  Created by 정성윤 on 8/23/24.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: SettingViewModel
    @State var isPresented: Bool = false
    
    var body: some View {
        contentView
            .fullScreenCover(isPresented: $isPresented) {
                NickNameView(viewModel: viewModel, isPresented: $isPresented, type: .change)
                    .presentationBackground(.black.opacity(0.7))
            }
            .onChange(of: isPresented) {
                if isPresented == false {
                    viewModel.send(action: .getLoad)
                }
            }
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear{
                    viewModel.send(action: .getLoad)
                }
        case .loading:
            LoadingView(url: "congratulations", size: [150, 150])
        case .success:
            loadedView
        case .fail:
            loadedView
                .onAppear {
                    viewModel.userNickname = "닉네임을 설정해 주세요"
                }
        }
    }
    
    var loadedView: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 30) {
                    SettingProfileView(isPresented: $isPresented)
                        .environmentObject(viewModel)
                        .environmentObject(authViewModel)
                    
                    setting
                    
                    GADBannerViewController(type: .banner)
                        .frame(width: UIScreen.main.bounds.width - 40, height: (UIScreen.main.bounds.width - 40) / 3.2)
                    
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("logo")
                }
            }
        }
    }
    
    var setting: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                Text("계정 설정")
                    .foregroundColor(.black)
                    .font(.system(size: 15, weight: .bold))
                Spacer()
            }
            .padding(.leading, -10)
            
            VStack(spacing: 10) {
                ForEach(SettingType.allCases, id: \.self) { cases in
                    if cases != .bell {
                        if (cases == .logout) || (cases == .withdraw) {
                            if let memberState = (UserDefaults.standard.value(forKey: "nonMember")) {
                                if memberState as! String == "false" {
                                    SettingDetailView(cases: cases)
                                }
                            } else {
                                ErrorView()
                                    .onAppear {
                                        authViewModel.authState = .unAuth
                                        authViewModel.refreshTokenState = .Expired
                                    }
                            }
                        } else {
                            SettingDetailView(cases: cases)
                        }
                    } else {
                        SettingBellView(isPresented: $isPresented, cases: cases)
                    }
                }
            }
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    SettingView(viewModel: SettingViewModel(container: .init(services: StubServices())))
        .environmentObject(AuthViewModel(container: .init(services: StubServices()), authState: .auth))
}
