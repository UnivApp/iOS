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
        VStack(alignment: .center, spacing: 20) {
            Image("smile")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .padding(15)
                .overlay {
                    RoundedRectangle(cornerRadius: 15).stroke(.black, lineWidth: 4)
                }
            
            Text(viewModel.userNickname)
                .foregroundColor(.black)
                .font(.system(size: 20, weight: .bold))
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
}
