//
//  EventViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import Foundation
import Combine

struct ChatState<T> {
    var data: [[T]]?
    var currentIndex: Int? {
        return data?.count ?? 0 > 0 ? (data?.count ?? 0) - 1 : nil
    }
}

enum chatScrollType {
    case news
    case ranking
    case rent
    case employment
    case mou
    case food
    case hotplace
    case ontime
    case Occasion
}

class ChatViewModel: ObservableObject {
    
    @Published var phase: Phase = .notRequested
    @Published var chatList: [String] = ["안녕하세요! 제 이름은 위봇입니다", "무엇을 도와드릴까요 💭"]
    @Published var mineList: [String] = ["", ""]
    
    @Published var universityName: String = ""
    @Published var isUniversityTyping: [Bool] = [false, false]
    @Published var isScrollType: chatScrollType? = nil
    
    //MARK: - Data
    @Published var foodState = ChatState<FoodModel>()
    @Published var newsState = ChatState<NewsModel>()
    @Published var rankState = ChatState<InitiativeModel>()
    @Published var rentState = ChatState<MoneyModel>()
    @Published var mouState = ChatState<MouModel>()
    @Published var hotplaceState = ChatState<PlayDetailModel>()
    @Published var employmentState = ChatState<EmploymentRateResponses>()
    @Published var rateState = ChatState<CompetitionRateResponses>()
    
    private var container: DIContainer
    private var subscripttions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: ChatType) {
        switch action {
        case .food:
            self.phase = .loading
            container.services.foodService.getTopRestaurants()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] (topFood) in
                    self?.isScrollType = .food
                    self?.ensureDataCapacity(state: &self!.foodState, index: (self?.chatList.count ?? 0) - 1)
                    self?.foodState.data?[(self?.chatList.count ?? 0) - 1] = topFood
                    self?.appendTotal("다른 대학교가 궁금하신가요? 🎓")
                    self?.isUniversityTyping[(self?.chatList.count ?? 0) - 1] = true
                    self?.phase = .success
                }.store(in: &subscripttions)
            
        case .news:
            self.phase = .loading
            
        case .ranking:
            self.phase = .loading
            
        case .rent:
            self.phase = .loading
            
        case .mou:
            self.phase = .loading
            
        case .hotplace:
            self.phase = .loading
            
        case .employment:
            self.phase = .loading
            
        case .ontime:
            self.phase = .loading
            
        case .Occasion:
            self.phase = .loading
            
        }
    }
    
    func subSend(action: ChatType) {
        switch action {
        case .food:
            self.phase = .loading
            container.services.searchService.getSearch(searchText: universityName)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.appendTotal("검색 결과를 찾을 수 없어요 😢")
                        self?.phase = .notRequested
                        self?.isUniversityTyping[(self?.chatList.count ?? 0) - 1] = false
                    }
                } receiveValue: { [weak self] searchResult in
                    if let universityId = searchResult.compactMap({ $0.universityId }).first {
                        self?.container.services.foodService.getSchoolRestaurants(universityId:  universityId)
                            .sink { [weak self] completion in
                                if case .failure = completion {
                                    self?.appendTotal("검색 결과를 찾을 수 없어요 😢")
                                    self?.phase = .notRequested
                                    self?.isUniversityTyping[(self?.chatList.count ?? 0) - 1] = false
                                }
                            } receiveValue: { [weak self] foodSearch in
                                self?.isScrollType = .food
                                self?.appendTotal("\(self?.universityName ?? "") 주변 맛집 정보입니다!")
                                self?.ensureDataCapacity(state: &self!.foodState, index: (self?.chatList.count ?? 0) - 1)
                                self?.foodState.data?[(self?.chatList.count ?? 0) - 1] = foodSearch
                                self?.appendTotal("더 자세한 정보를 알고 싶으신가요? 👀")
                                self?.phase = .notRequested
                                self?.isUniversityTyping[(self?.chatList.count ?? 0) - 1] = true
                            }.store(in: &self!.subscripttions)
                    }
                }.store(in: &subscripttions)

            
        case .news:
            self.phase = .loading
            
        case .ranking:
            self.phase = .loading
            
        case .rent:
            self.phase = .loading
            
        case .mou:
            self.phase = .loading
            
        case .hotplace:
            self.phase = .loading
            
        case .employment:
            self.phase = .loading
            
        case .ontime:
            self.phase = .loading
            
        case .Occasion:
            self.phase = .loading
            
        }
    }
    
    func ensureDataCapacity<T>(state: inout ChatState<T>, index: Int) {
        if state.data == nil {
            state.data = []
        }
        
        while state.data?.count ?? 0 <= index {
            state.data?.append([])
        }
    }
    
    func appendTotal(_ string: String) {
        self.chatList.append("")
        self.mineList.append("")
        self.isUniversityTyping.append(false)
        self.chatList[chatList.count - 1] = string
    }
    
    func appendChatList(_ string: String) {
        self.chatList.append("")
        self.chatList[chatList.count - 1] = string
    }
    
    func appendMineList(_ string: String) {
        self.mineList.append("")
        self.mineList[mineList.count - 1] = string
    }
    
    func calculateDate() -> String {
        let today = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일 EEEE"
        return formatter.string(from: today)
    }
    
}

