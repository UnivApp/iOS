//
//  SettingView.swift
//  UnivApp
//
//  Created by 정성윤 on 8/23/24.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var container: DIContainer
    @StateObject var viewModel: SettingViewModel
    
    var body: some View {
        contentView
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear{
                    viewModel.send(action: .load)
                }
        case .loading:
            LoadingView(url: "congratulations")
        case .success:
            loadedView
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        NavigationStack {
            Spacer()
            
            profile
            
            Spacer()
            
            setting
                .padding(.bottom, 30)
            
            support
            
            Spacer()
        }
    }
    
    var profile: some View {
        VStack(alignment: .center) {
            Image("person")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 100)
                .padding(.horizontal, 20)
            
            Text("성윤님")
                .foregroundColor(.black)
                .font(.system(size: 20, weight: .bold))
                .padding(.top, 10)
            
            
            Text("jeoungsung12@naver.com")
                .foregroundColor(.black)
                .font(.system(size: 12, weight: .regular))
                .padding(.top, 10)
            
        }
    }
    
    var setting: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("계정 설정")
                .foregroundColor(.gray)
                .font(.system(size: 10, weight: .bold))
                .padding(.leading, 20)
                .padding(.bottom, 20)
            
            
            ForEach(SettingType.allCases, id: \.self) { cases in
                NavigationLink(destination: cases.view) {
                    HStack {
                        Text("\(cases.title)")
                            .foregroundColor(.black)
                            .font(.system(size: 14, weight: .bold))
                            .padding(.leading, 30)
                        
                        Spacer()
                        
                        Image("arrow_fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 5, height: 10)
                            .padding(.trailing, 30)
                    }
                    .padding(.bottom, 10)
                }
            }
        }
    }
    
    var support: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("지원")
                .foregroundColor(.gray)
                .font(.system(size: 10, weight: .bold))
                .padding(.leading, 20)
                .padding(.bottom, 20)
            
            
            ForEach(SupportType.allCases, id: \.self) { cases in
                NavigationLink(destination: cases.view) {
                    HStack {
                        Text("\(cases.title)")
                            .foregroundColor(.black)
                            .font(.system(size: 14, weight: .bold))
                            .padding(.leading, 30)
                        
                        Spacer()
                        
                        Image("arrow_fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 5, height: 10)
                            .padding(.trailing, 30)
                    }
                    .padding(.bottom, 10)
                }
            }
        }
    }
}

#Preview {
    SettingView(viewModel: SettingViewModel(container: .init(services: StubServices())))
        .environmentObject(AuthViewModel(container: .init(services: StubServices())))
        .environmentObject(DIContainer(services: StubServices()))
}
