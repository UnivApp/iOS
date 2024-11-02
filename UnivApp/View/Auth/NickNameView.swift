//
//  NickNameView.swift
//  UnivApp
//
//  Created by 정성윤 on 11/1/24.
//

import SwiftUI

enum NickNameType {
    case create
    case change
}

struct NickNameView: View {
    @StateObject var viewModel: SettingViewModel
    @Binding var isPresented: Bool
    @State private var checkStateStress: Bool = false
    var type: NickNameType
    
    var body: some View {
        loadedView
            .onAppear { viewModel.nickNamePhase = .notRequested }
    }
    @ViewBuilder
    var loadedView: some View {
        ZStack {
            VStack(alignment: .center, spacing: 30) {
                Text("닉네임 설정")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                
                HStack {
                    TextField(text: $viewModel.nickNameText) {
                        Text("닉네임을 입력하세요!")
                    }
                    .font(.system(size: 15, weight: .semibold))
                    
                    Button {
                        if viewModel.nickNameText != "" {
                            viewModel.send(action: .checkLoad)
                        }
                    } label: {
                        Text("중복확인")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.blue.opacity(0.7))
                    }
                    .padding(.trailing, 10)
                }
                .padding(15)
                .background(RoundedRectangle(cornerRadius: 5).stroke(.gray, lineWidth: 1))
                .padding(.horizontal, 10)
                
                if let duplicatePhase = viewModel.duplicatePhase {
                    Text("\(duplicatePhase ? "사용 가능한 닉네임 입니다!" : "사용 불가한 닉네임 입니다!")")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(duplicatePhase ? .blue.opacity(0.7) : .red.opacity(0.7))
                } else {
                    Text("닉네임 중복 체크를 해주세요 ✅")
                        .font(.system(size: 12, weight: checkStateStress ? .heavy : .semibold))
                        .foregroundColor(checkStateStress ? .red.opacity(0.7) : .gray)
                }
                
                Divider()
                
                if type == .create {
                    Button {
                        if (viewModel.duplicatePhase ?? false) {
                            viewModel.send(action: .createLoad)
                            viewModel.nickNameText = ""
                        } else { 
                            viewModel.duplicatePhase = nil
                            checkStateStress = true
                        }
                    } label: {
                        Text("생성하기")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor((viewModel.duplicatePhase ?? false) ? .orange : .gray)
                    }
                } else {
                    HStack(alignment: .center, spacing: 40) {
                        Button {
                            isPresented = false
                        } label: {
                            Text("취소하기")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.gray)
                        }
                        Divider()
                        Button {
                            if (viewModel.duplicatePhase ?? false) {
                                viewModel.send(action: .changeLoad)
                                viewModel.nickNameText = ""
                            } else {
                                viewModel.duplicatePhase = nil
                                checkStateStress = true
                            }
                        } label: {
                            Text("변경하기")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor((viewModel.duplicatePhase ?? false) ? .orange : .gray)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            if viewModel.nickNamePhase == .success {
                VStack(alignment: .center, spacing: 10){
                    Text("닉네임이 \(type == .create ? "생성" : "변경") 되었습니다!")
                        .font(.system(size: 15, weight: .heavy))
                        .foregroundColor(.white)
                    LoadingView(url: "congratulations", size: [100, 100])
                }
                .padding(20)
                .background(RoundedRectangle(cornerRadius: 15).fill(.orange.opacity(0.8)))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        isPresented = false
                    }
                }
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 15).fill(.white))
        .frame(width: UIScreen.main.bounds.width - 60, height: UIScreen.main.bounds.height / 3)
    }
}

struct NickNameView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isPresented: Bool = true
        NickNameView(viewModel: SettingViewModel(container: .init(services: StubServices())), isPresented: $isPresented, type: .create)
    }
}
