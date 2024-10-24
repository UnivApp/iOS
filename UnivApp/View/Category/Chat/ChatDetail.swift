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
                    .foregroundColor(.black)
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
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    viewModel.chatList[viewModel.chatList.count - 1] = ("\(type.title)에 대해 궁금하시군요! 제가 알려드릴게요 🧐")
                                    viewModel.send(action: type)
                                }
                            }
                        } label: {
                            Text(type.title)
                                .font(.system(size: 11, weight: .heavy))
                                .foregroundColor(self.chatType == type ? .white : .black.opacity(0.5))
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 15).fill(self.chatType == type ? .orange : .white).stroke(self.chatType == type ? .orange : .gray, lineWidth: 1))
                        }
                        
                    }
                }
            }
        }
        .padding(.horizontal, 0)
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
            HStack(spacing: 10) {
                Image("chatIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding(5)
                    .background(Circle().fill(Color.white))
                    .overlay(
                        Circle()
                            .stroke(.gray.opacity(0.5), lineWidth: 1)
                    )
                Text("위봇")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
            }
            HStack(spacing: 10) {
                Text(viewModel.chatList[index] == "" ? "💬" : viewModel.chatList[index])
                    .padding(10)
                    .background(.backGray)
                    .cornerRadius(10)
                    .foregroundColor(.black.opacity(0.7))
                    .font(.system(size: 15, weight: .semibold))
                    .onAppear {
                        
                    }
                Spacer()
            }
            .padding(.leading, 40)
            
            if (viewModel.isUniversityTyping) && (viewModel.chatList[index].contains("?")) {
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
                    HStack {
                        ChatPopup(viewModel: viewModel, chatType: $chatType, isAlert: $isAlert, focusState: _focusState)
                        Spacer()
                    }
                    .padding(.leading, 40)
                }
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
                    .font(.system(size: 15, weight: .semibold))
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
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            TextField("대학이름을 입력하세요", text: $viewModel.universityName)
                .background(.backGray)
                .submitLabel(.search)
                .onSubmit {
                    if let chatType = chatType {
                        viewModel.subSend(action: chatType)
                        viewModel.universityName = ""
                    }
                }
                .padding(.horizontal, 10)
                .multilineTextAlignment(.center)
            
            Button {
                if let chatType = chatType {
                    viewModel.subSend(action: chatType)
                    isAlert = false
                    focusState = false
                    viewModel.phase = .notRequested
                }
            } label: {
                Text("검색")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black.opacity(0.7))
            }
            Spacer()
        }
        .background(.backGray)
        .frame(width: UIScreen.main.bounds.width / 2, height: 100)
        .cornerRadius(15)
    }
}



struct Previews: PreviewProvider {
    static var previews: some View {
        mineListView(viewModel: ChatViewModel(container: .init(services: StubServices())), index: 0)
    }
}
