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
    @Binding var isPresented: Bool
    
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
                                isPresented = false
                                viewModel.isUniversityTyping.append(false)
                                viewModel.isScrollType.append(nil)
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
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .padding(.bottom, 70)
        .background(.white)
        .cornerRadius(40)
        .shadow(color: .orange, radius: 2)
    }
}

struct chatListView: View {
    @StateObject var viewModel: ChatViewModel
    @Binding var isAlert: Bool
    @Binding var chatType: ChatType?
    @FocusState var focusState: Bool
    
    @State private var isMore: Bool = false
    @State private var isSheet: Bool = false
    
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
                    .foregroundColor(.black.opacity(0.8))
                    .font(.system(size: 15, weight: .semibold))
                    .onAppear {
                        
                    }
                Spacer()
            }
            .padding(.leading, 40)
            
            if (viewModel.isUniversityTyping[index]) && (viewModel.chatList[index].contains("?")) {
                HStack(spacing: 20) {
                    ForEach(0...1, id: \.self) { index in
                        Button {
                            if viewModel.chatList[self.index].contains("🎓") {
                                if index == 0 {
                                    self.isAlert = true
                                    viewModel.isUniversityTyping[self.index] = false
                                } else {
                                    self.isAlert = false
                                    viewModel.isUniversityTyping[self.index] = false
                                }
                            } else {
                                if index == 0 {
                                    self.isAlert = false
                                    viewModel.isUniversityTyping[self.index] = false
                                    self.isMore = true
                                } else {
                                    self.isAlert = false
                                    viewModel.isUniversityTyping[self.index] = false
                                    self.isMore = false
                                }
                            }
                        } label: {
                            Text(index == 0 ? "예" : "아니오")
                                .padding(10)
                                .foregroundColor(index != 0 ? .red.opacity(0.7) : .blue.opacity(0.7))
                                .font(.system(size: 15, weight: .semibold))
                                .background(.clear)
                                .cornerRadius(15)
                        }
                        .frame(height: 20)
                    }
                    Spacer()
                }
                .padding(.leading, 40)
                .padding(.vertical, 20)
            }
            
            if isMore {
                detailNavigation
            }
        }
        .padding(.trailing, 10)
        .padding(.bottom, 20)
        .sheet(isPresented: $isSheet) {
            if let view = chatType?.view {
                view
            }
        }
    }
    
    var detailNavigation: some View {
        HStack {
            Spacer()
            Button(action: {
                self.isSheet = true
            }, label: {
                HStack {
                    Spacer()
                    Text("자세히 보기 👉🏻")
                        .padding(5)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black.opacity(0.7))
                }
                .padding(.top, 10)
                .padding(.horizontal, 40)
            })
        }
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

struct ChatSearchView: View {
    @StateObject var viewModel: ChatViewModel
    @FocusState private var isTextFieldFocused: Bool
    @Binding var chatType: ChatType?
    @Binding var isAlert: Bool
    var body: some View {
        HStack {
            Button {
                isTextFieldFocused = false
                isAlert = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 10)
            Spacer()
            VStack(alignment: .center, spacing: 20) {
                HStack {
                    Button {
                        if let chatType = chatType {
                            isAlert = false
                            isTextFieldFocused = false
                            viewModel.isUniversityTyping.append(false)
                            viewModel.isScrollType.append(nil)
                            viewModel.mineList[viewModel.mineList.count - 1] = (viewModel.universityName)
                            viewModel.mineList.append("")
                            viewModel.chatList.append("")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                viewModel.chatList[viewModel.chatList.count - 1] = ("\(viewModel.universityName) 궁금하시군요 🤔")
                                viewModel.subSend(action: chatType)
                            }
                        }
                    } label: {
                        Image("search")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                    }
                    .padding()
                    
                    TextField("대학명/소재지를 입력하세요", text: $viewModel.universityName)
                        .font(.system(size: 15, weight: .regular))
                        .focused($isTextFieldFocused)
                        .padding()
                        .submitLabel(.search)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                isTextFieldFocused = true
                            }
                        }
                        .onSubmit {
                            if let chatType = chatType {
                                isAlert = false
                                isTextFieldFocused = false
                                viewModel.isUniversityTyping.append(false)
                                viewModel.isScrollType.append(nil)
                                viewModel.mineList[viewModel.mineList.count - 1] = (viewModel.universityName)
                                viewModel.mineList.append("")
                                viewModel.chatList.append("")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    viewModel.chatList[viewModel.chatList.count - 1] = ("\(viewModel.universityName) 궁금하시군요 🤔")
                                    viewModel.subSend(action: chatType)
                                }
                            }
                        }
                }
                .padding(.horizontal, 10)
                .background(Color.white)
                .border(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .leading, endPoint: .trailing), width: 1)
                .cornerRadius(15)
                .overlay (
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .leading, endPoint: .trailing), lineWidth: 1.5)
                )
            }
            .padding(.trailing, 10)
            .padding(.vertical, 10)
            .onAppear {
                viewModel.universityName = ""
            }
        }
        .background(.white)
    }
}


struct Previews: PreviewProvider {
    static var previews: some View {
        @State var ChatType: ChatType? = .Occasion
        @State var isPresented: Bool = true
        @State var isAlert: Bool = true
        ChatQuestionView(viewModel: ChatViewModel(container: .init(services: StubServices())), chatType: $ChatType, isPresented: $isAlert)
    }
}
