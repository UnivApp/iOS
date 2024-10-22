//
//  EventViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import Foundation
import Combine

class ChatViewModel: ObservableObject {
    
    @Published var phase: Phase = .notRequested
    @Published var chatList: [String] = ["안녕하세요! 무엇을 도와드릴까요?"]
    @Published var mineList: [String] = [""]
    @Published var universityName: String = ""
    @Published var isLoading: Bool = false
    @Published var isUniversityTyping: Bool = false
    @Published var isScrollData: Bool = false
    
    private var container: DIContainer
    private var subscripttions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: ChatType) {
        switch action {
        case .food:
            self.chatList.append("")
            self.phase = .loading
            container.services.foodService.getTopRestaurants()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] (topFood) in
                    var foodString: String = ""
                    for index in 0...3 {
                        foodString += "\(index+1). \(topFood[index].topMessage ?? "")으로는\n'\(topFood[index].name)'이 있습니다.\n\n"
                        for hashtag in topFood[index].hashtags {
                            foodString += "\(hashtag), "
                        }
                        foodString += "\n\n"
                    }
                    self?.appendChatList(foodString)
                    self?.appendChatList("다른 대학교가 궁금하신가요?")
                    self?.isUniversityTyping = true
                    self?.phase = .success
                }.store(in: &subscripttions)
            
        case .news:
            self.chatList.append("")
            self.phase = .loading
            
        case .ranking:
            self.chatList.append("")
            self.phase = .loading
            
        case .rent:
            self.chatList.append("")
            self.phase = .loading
            
        case .info:
            self.chatList.append("")
            self.phase = .loading
            
        case .hotplace:
            self.chatList.append("")
            self.phase = .loading
            
        case .employment:
            self.chatList.append("")
            self.phase = .loading
            
        case .ontime:
            self.chatList.append("")
            self.phase = .loading
            
        case .Occasion:
            self.chatList.append("")
            self.phase = .loading
            
        }
    }
    
    func subSend(action: ChatType) {
        switch action {
        case .food:
            self.chatList.append("")
            self.phase = .loading
            container.services.searchService.getSearch(searchText: universityName)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        if let count = self?.chatList.count {
                            self?.appendChatList("검색 결과를 찾을 수 없어요 😢")
                            self?.phase = .notRequested
                        }
                    }
                } receiveValue: { [weak self] searchResult in
                    if let universityId = searchResult.compactMap({ $0.universityId }).first {
                        self?.container.services.foodService.getSchoolRestaurants(universityId:  universityId)
                            .sink { [weak self] completion in
                                if case .failure = completion {
                                    self?.appendChatList("검색 결과를 찾을 수 없어요 😢")
                                    self?.phase = .notRequested
                                }
                            } receiveValue: { [weak self] foodSearch in
                                guard self != nil else { return }
                            }
                    }
                }.store(in: &subscripttions)

            
        case .news:
            self.chatList.append("")
            self.phase = .loading
            
        case .ranking:
            self.chatList.append("")
            self.phase = .loading
            
        case .rent:
            self.chatList.append("")
            self.phase = .loading
            
        case .info:
            self.chatList.append("")
            self.phase = .loading
            
        case .hotplace:
            self.chatList.append("")
            self.phase = .loading
            
        case .employment:
            self.chatList.append("")
            self.phase = .loading
            
        case .ontime:
            self.chatList.append("")
            self.phase = .loading
            
        case .Occasion:
            self.chatList.append("")
            self.phase = .loading
            
        }
    }
    
    func appendChatList(_ string: String) {
        self.chatList[chatList.count - 1] = string
        self.chatList.append("")
    }
    
    func appendMineList(_ string: String) {
        self.mineList[mineList.count - 1] = string
        self.mineList.append("")
    }
    
}

