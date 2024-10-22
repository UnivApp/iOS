//
//  EventView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import SwiftUI

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel
    @Environment(\.dismiss) var dismiss
    @State private var chatType: ChatType? = nil
    @State private var isAlert: Bool = false
    @FocusState private var focusState: Bool
    
    var body: some View {
        contentView
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .toolbar(.hidden, for: .navigationBar)
            .focused($focusState)
    }
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            loadedView
        case .loading:
            loadedView
                .onAppear {
                    viewModel.isLoading = true
                }
        case .success:
            loadedView
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("blackback")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    VStack(alignment: .center, spacing: 20) {
                        let chatCount = viewModel.chatList.count
                        let mineCount = viewModel.mineList.count
                        let totalCount = max(chatCount, mineCount)
                        
                        ForEach(0..<totalCount, id: \.self) { index in
                            if index < chatCount {
                                chatListView(viewModel: viewModel, isAlert: $isAlert, chatType: $chatType, focusState: _focusState, index: index)
                                    .id(index)
                            }
                            if index < mineCount {
                                mineListView(viewModel: viewModel, index: index)
                                    .id(index)
                            }
                        }
                        .font(.system(size: 15, weight: .semibold))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
                .task {
                    if viewModel.chatList[viewModel.chatList.count - 1] != "" {
                        proxy.scrollTo(viewModel.chatList.count-1, anchor: .bottom)
                    }
                }
                .task {
                    if viewModel.mineList[viewModel.mineList.count - 1] != "" {
                        proxy.scrollTo(viewModel.chatList.count-1, anchor: .bottom)
                    }
                }
            }
            
            if (viewModel.phase == .notRequested) || ((viewModel.phase == .success) && (viewModel.isUniversityTyping == false)) {
                ChatQuestionView(viewModel: viewModel, chatType: $chatType)
                    .padding(.bottom, 20)
            }
        }
        .background(.orange.opacity(0.1))
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(viewModel: ChatViewModel(container: .init(services: StubServices())))
    }
}

