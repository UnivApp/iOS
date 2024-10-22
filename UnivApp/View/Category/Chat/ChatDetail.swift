//
//  ChatDetailView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/5/24.
//

import SwiftUI

struct ChatQuestionView: View {
    @StateObject var viewModel: ChatViewModel
    @Binding var chatType: ChatType?
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("궁금한 점을 물어보세요!")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black.opacity(0.7))
                Spacer()
            }
            HStack {
                let columns = Array(repeating: GridItem(.flexible()), count: 4)
                LazyVGrid(columns: columns) {
                    ForEach(ChatType.allCases, id: \.self) { type in
                        Button {
                            withAnimation {
                                chatType = type
                                viewModel.mineList[viewModel.mineList.count - 1] = ("\(type.title)")
                                viewModel.mineList.append("")
                                viewModel.chatList.append("")
                                viewModel.isLoading = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    viewModel.chatList[viewModel.chatList.count - 1] = ("\(type.title)에 대해 궁금하시군요! 제가 알려드릴게요 🧐")
                                    viewModel.isLoading = false
                                    viewModel.send(action: type)
                                }
                            }
                        } label: {
                            Text(type.title)
                                .font(.system(size: 12, weight: .heavy))
                                .foregroundColor(self.chatType == type ? .white : .gray)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 15).fill(self.chatType == type ? .orange : .white))
                        }
                        
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct chatListView: View {
    @StateObject var viewModel: ChatViewModel
    @Binding var isAlert: Bool
    @Binding var chatType: ChatType?
    @FocusState var focusState: Bool
    var index: Int
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Image("chat6")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding(5)
                    .background(.white)
                    .clipShape(Circle())
                Spacer()
            }
            HStack(spacing: 10) {
                if (viewModel.isLoading) && (viewModel.chatList[index] == "") {
                    LoadingView(url: "chat", size: [40, 40])
                        .cornerRadius(15)
                }
                Text(viewModel.chatList[index])
                    .padding(10)
                    .background(viewModel.chatList[index] == "" ? .clear : .white)
                    .cornerRadius(10)
                    .foregroundColor(.black.opacity(0.7))
                Spacer()
            }
            .padding(.leading, 40)
            
            if (viewModel.isUniversityTyping) && ((viewModel.chatList[index] == "다른 대학교가 궁금하신가요?" || viewModel.chatList[index] == "더 많은 결과를 자세히 보시겠습니까?")) {
                HStack(spacing: 20) {
                    ForEach(0...1, id: \.self) { index in
                        Button {
                            if index == 0 {
                                self.isAlert = true
                            } else {
                                viewModel.phase = .notRequested
                                viewModel.isUniversityTyping = false
                            }
                        } label: {
                            Text(index == 0 ? "예" : "아니오")
                                .padding(10)
                                .foregroundColor(index != 0 ? .red.opacity(0.7) : .blue.opacity(0.7))
                                .font(.system(size: 15, weight: .semibold))
                                .background(.white)
                                .cornerRadius(15)
                        }
                        .frame(height: 20)
                    }
                    Spacer()
                }
                .padding(.leading, 40)
                .padding(.vertical, 20)
                
                if isAlert {
                    ChatPopup(viewModel: viewModel, chatType: $chatType, isAlert: $isAlert, focusState: _focusState)
                }
            }
            
            if (viewModel.isScrollData) {
                
            }
        }
        .padding(.trailing, 10)
    }
}

struct mineListView: View {
    @StateObject var viewModel: ChatViewModel
    var index: Int
    var body: some View {
        if viewModel.mineList[index] != "" {
            HStack {
                Spacer()
                Text(viewModel.mineList[index])
                    .padding(10)
                    .background(.orange)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            .padding(.leading, 10)
        }
    }
}

struct ChatPopup: View {
    @StateObject var viewModel: ChatViewModel
    @Binding var chatType: ChatType?
    @Binding var isAlert: Bool
    @FocusState var focusState: Bool
    var body: some View {
        VStack {
            TextField("대학이름을 입력하세요!", text: $viewModel.universityName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .submitLabel(.search)
                .onSubmit {
                    if let chatType = chatType {
                        viewModel.subSend(action: chatType)
                        viewModel.universityName = ""
                    }
                }
            
            Button {
                if let chatType = chatType {
                    viewModel.subSend(action: chatType)
                    self.isAlert = false
                    self.focusState = false
                }
            } label: {
                Text("검색")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black.opacity(0.7))
            }
            .padding()
        }
        .background(.white)
        .frame(width: UIScreen.main.bounds.width / 3, height: 100)
        .cornerRadius(15)
    }
}

struct chatScrollView: View {
    @StateObject var viewModel: ChatViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            
        }
    }
}
