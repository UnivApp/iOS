//
//  EventView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import SwiftUI

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel
    @State private var chatType: ChatType? = nil
    @State private var isAlert: Bool = false
    @State private var isPresented: Bool = true
    @FocusState private var isTextFieldFocused: Bool
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        contentView
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .toolbar(.hidden, for: .navigationBar)
            .onTapGesture {
                isTextFieldFocused = false
            }
    }
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            loadedView
        case .loading:
            loadedView
        case .success:
            loadedView
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        VStack(alignment: .center, spacing: 10) {
            ChatNavigationView(dismiss: _dismiss)
            ZStack {
                ScrollViewReader { proxy in
                    ScrollView(.vertical) {
                        VStack(alignment: .center, spacing: 20) {
                            Text(viewModel.calculateDate())
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.gray)
                            
                            let chatCount = viewModel.chatList.count
                            let mineCount = viewModel.mineList.count
                            let totalCount = max(chatCount, mineCount)
                            
                            ForEach(0..<totalCount, id: \.self) { index in
                                if index < chatCount {
                                    VStack {
                                        chatListView(viewModel: viewModel, isAlert: $isAlert, chatType: $chatType, index: index)
                                        switch viewModel.isScrollType[index] {
                                        case .news:
                                            if let newsData = viewModel.newsState.data, index < newsData.count , newsData[index] != [] {
                                                HStack {
                                                    LoadingView(url: "chat_news", size: [100, 100])
                                                        .padding(.leading, 40)
                                                    Spacer()
                                                }
                                                ChatScrollView(news: newsData[index])
                                            }
                                        case .ranking:
                                            if let rankData = viewModel.rankState.data, index < rankData.count , rankData[index] != [] {
                                                HStack {
                                                    LoadingView(url: "chat_rank", size: [100, 100])
                                                        .padding(.leading, 40)
                                                    Spacer()
                                                }
                                                ChatScrollView(rank: rankData[index])
                                            }
                                        case .rent:
                                            Color.clear
                                        case .employment:
                                            if let employData = viewModel.employmentState.data, index < employData.count , employData[index] != [] {
                                                HStack {
                                                    LoadingView(url: "chat_rate", size: [100, 100])
                                                        .padding(.leading, 40)
                                                    Spacer()
                                                }
                                                ChatScrollView(employment: employData[index])
                                            }
                                        case .mou:
                                            if let mouData = viewModel.mouState.data, index < mouData.count , mouData[index] != [] {
                                                HStack {
                                                    LoadingView(url: "chat_mou", size: [100, 100])
                                                        .padding(.leading, 40)
                                                    Spacer()
                                                }
                                                ChatScrollView(mou: mouData[index])
                                            }
                                        case .food:
                                            if let foodData = viewModel.foodState.data, index < foodData.count , foodData[index] != [] {
                                                HStack {
                                                    LoadingView(url: "chat_food", size: [100, 100])
                                                        .padding(.leading, 40)
                                                    Spacer()
                                                }
                                                ChatScrollView(food: foodData[index])
                                            }
                                        case .hotplace:
                                            if let hotplaceData = viewModel.hotplaceState.data, index < hotplaceData.count , hotplaceData[index] != [] {
                                                HStack {
                                                    LoadingView(url: "chat_play", size: [100, 100])
                                                        .padding(.leading, 40)
                                                    Spacer()
                                                }
                                                ChatScrollView(hotplace: hotplaceData[index])
                                            }
                                        case .ontime:
                                            if let ontimeData = viewModel.ontimeState.data, index < ontimeData.count , ontimeData[index] != [] {
                                                HStack {
                                                    LoadingView(url: "chat_rate", size: [100, 100])
                                                        .padding(.leading, 40)
                                                    Spacer()
                                                }
                                                ChatScrollView(ontime: ontimeData[index])
                                            }
                                        case .Occasion:
                                            if let occasionData = viewModel.occasionState.data, index < occasionData.count , occasionData[index] != [] {
                                                HStack {
                                                    LoadingView(url: "chat_rate", size: [100, 100])
                                                        .padding(.leading, 40)
                                                    Spacer()
                                                }
                                                ChatScrollView(occasion: occasionData[index])
                                            }
                                        case .none:
                                            Color.clear
                                        }
                                    }
                                    .id(index)
                                }
                                if index < mineCount {
                                    mineListView(viewModel: viewModel, index: index)
                                        .id(index)
                                }
                            }
                            .font(.system(size: 15, weight: .semibold))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 20)
                    }
                    .task {
                        withAnimation {
                            proxy.scrollTo(viewModel.chatList.count-1, anchor: .bottom)
                        }
                    }
                    .task {
                        withAnimation {
                            proxy.scrollTo(viewModel.mineList.count-1, anchor: .bottom)
                        }
                    }
                    .onChange(of: isPresented) {
                        withAnimation {
                            let MaxCount: Int = max((viewModel.chatList.count - 1), (viewModel.chatList.count - 1))
                            proxy.scrollTo(MaxCount, anchor: .bottom)
                        }
                    }
                }
                VStack {
                    Spacer()
                    QuestionButton(isPresented: $isPresented)
                }
            }
            if isPresented {
                ChatQuestionView(viewModel: viewModel, chatType: $chatType, isPresented: $isPresented)
                    .padding(.bottom, -50)
            }
            if isAlert {
                ChatSearchView(viewModel: viewModel, chatType: $chatType, isAlert: $isAlert)
            }
        }
        .background(.white)
    }
}

fileprivate struct QuestionButton: View {
    @Binding var isPresented: Bool
    var body: some View {
        Button {
            withAnimation {
                isPresented.toggle()
            }
        } label: {
            Image(isPresented ? "arrow_up" : "arrow_down")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
        }
        .padding(.vertical, 10)
        .background(.clear)
    }
}

fileprivate struct ChatNavigationView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                HStack(spacing: 10) {
                    Image("blackback")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
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
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(viewModel: ChatViewModel(container: .init(services: StubServices())))
    }
}

