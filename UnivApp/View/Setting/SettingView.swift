//
//  SettingView.swift
//  UnivApp
//
//  Created by 정성윤 on 8/23/24.
//

import SwiftUI

struct SettingView: View {
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
                VStack(spacing: 20) {
                    profile
                    
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
    
    var profile: some View {
        VStack(alignment: .center, spacing: 0) {
            Image("smile")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .padding(.top, 20)
            
            Group {
                Text("  \(viewModel.userNickname)")
                    .foregroundColor(.orange)
                    .font(.system(size: 25, weight: .heavy))
                +
                Text("님\n 환영합니다!")
                    .foregroundColor(.black)
                    .font(.system(size: 25, weight: .semibold))
            }
            .multilineTextAlignment(.center)
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
                    NavigationLink(destination: cases.view) {
                        VStack(spacing: 20) {
                            HStack {
                                HStack(alignment: .center, spacing: 10) {
                                    Text(cases.image)
                                        .font(.system(size: 20))
                                    VStack(alignment: .leading) {
                                        Text(cases.title)
                                            .foregroundColor(.black.opacity(0.7))
                                            .font(.system(size: 13, weight: .bold))
                                        
                                        Text(cases.description)
                                            .foregroundColor(.gray)
                                            .font(.system(size: 12, weight: .regular))
                                    }
                                    Spacer()
                                    Image("arrow_fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 15, height: 15)
                                }
                                .multilineTextAlignment(.leading)
                            }
                            Divider()
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    SettingView(viewModel: SettingViewModel(container: .init(services: StubServices())))
}
