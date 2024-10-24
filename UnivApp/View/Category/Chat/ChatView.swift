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
    @FocusState private var focusState: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        contentView
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .toolbar(.hidden, for: .navigationBar)
    }
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            loadedView
        case .loading:
            loadedView
                .onTapGesture {
                    focusState = false
                }
        case .success:
            loadedView
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        VStack(alignment: .center, spacing: 10) {
            ChatNavigationView(dismiss: _dismiss)
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
                                    chatListView(viewModel: viewModel, isAlert: $isAlert, chatType: $chatType, focusState: _focusState, index: index)
                                    if (viewModel.isScrollType == .food) {
                                        if let foodData = viewModel.foodState.data, index < foodData.count , foodData[index] != [] {
                                            ChatScrollView(food: foodData[index])
                                        } else {
                                        }
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
                        
                        Spacer()
                        
                        if (viewModel.phase == .notRequested) || ((viewModel.phase == .success) && (viewModel.isUniversityTyping == false)) {
                            ChatQuestionView(viewModel: viewModel, chatType: $chatType)
                                .id(viewModel.chatList.count-1)
                                .padding(.bottom, 20)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 20)
                }
                .task {
                    proxy.scrollTo(viewModel.chatList.count-1, anchor: .bottom)
                }
                .task {
                    proxy.scrollTo(viewModel.chatList.count-1, anchor: .bottom)
                }
            }
        }
        .background(.white)
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

