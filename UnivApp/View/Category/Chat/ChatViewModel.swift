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
    @Published var summaryArray: [SummaryModel] = []
    @Published var isUniversityTyping: [Bool] = [false, false]
    @Published var isScrollType: [chatScrollType?] = [nil, nil]
    @Published var averageRent: [String] = []
    
    //MARK: - Data
    @Published var foodState = ChatState<FoodModel>()
    @Published var newsState = ChatState<NewsModel>()
    @Published var rankState = ChatState<InitiativeModel>()
    @Published var mouState = ChatState<MouModel>()
    @Published var hotplaceState = ChatState<PlayModel>()
    @Published var employmentState = ChatState<EmploymentModel>()
    @Published var ontimeState = ChatState<CompetitionModel>()
    @Published var occasionState = ChatState<CompetitionModel>()
    
    private var container: DIContainer
    private var subscripttions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: ChatType) {
        switch action {
        case .food:
            self.phase = .loading
            self.appendTotal("궁금하신? 대학교를 알려주세요! 🎓")
            self.isUniversityTyping[(self.chatList.count) - 1] = true
            
        case .news:
            self.phase = .loading
            container.services.infoService.getNewsList()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] (newsData) in
                    self?.isScrollType[(self?.chatList.count ?? 0) - 1] = .news
                    self?.ensureDataCapacity(state: &self!.newsState, index: (self?.chatList.count ?? 0) - 1)
                    self?.newsState.data?[(self?.chatList.count ?? 0) - 1] = newsData
                    self?.appendTotal("더 자세한 정보를 알고 싶으신가요? 👀")
                    self?.isUniversityTyping[(self?.chatList.count ?? 0) - 1] = true
                    self?.phase = .success
                }.store(in: &subscripttions)
            
        case .ranking:
            self.phase = .loading
            container.services.rankingService.getRanking()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] (rankData) in
                    self?.isScrollType[(self?.chatList.count ?? 0) - 1] = .ranking
                    self?.ensureDataCapacity(state: &self!.rankState, index: (self?.chatList.count ?? 0) - 1)
                    self?.rankState.data?[(self?.chatList.count ?? 0) - 1] = rankData
                    self?.appendTotal("가장 대표적인 랭킹 정보인 'QS 세계대학 평가'에 대해 알려드렸습니다.")
                    self?.appendTotal("더 자세한 정보를 알고 싶으신가요? 👀")
                    self?.isUniversityTyping[(self?.chatList.count ?? 0) - 1] = true
                    self?.phase = .success
                }.store(in: &subscripttions)
            
        case .rent:
            self.phase = .loading
            container.services.moneyService.getRent(CGG_NM: "", BLDG_USG: "오피스텔")
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] (averageData) in
                    if  let response = averageData.tbLnOpendataRentV?.row,
                        let average = self?.calculateAverage(data: response) {
                        self?.appendTotal("서울 지역 오피스텔 기준 평균 월세입니다")
                        self?.isScrollType[(self?.chatList.count ?? 0) - 1] = .rent
                        self?.averageRent = average
                        self?.appendTotal("다른 대학교가 궁금하신가요? 🎓")
                        self?.isUniversityTyping[(self?.chatList.count ?? 0) - 1] = true
                        self?.phase = .success
                    }
                }.store(in: &subscripttions)
            
        case .mou:
            self.phase = .loading
            container.services.mouService.statusExpo(status: "OPEN")
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] mouData in
                    self?.appendTotal("현재 접수 진행 중인 대학 연계활동입니다!")
                    self?.isScrollType[(self?.chatList.count ?? 0) - 1] = .mou
                    self?.ensureDataCapacity(state: &self!.mouState, index: (self?.chatList.count ?? 0) - 1)
                    self?.mouState.data?[(self?.chatList.count ?? 0) - 1] = mouData
                    self?.appendTotal("더 자세한 정보를 알고 싶으신가요? 👀")
                    self?.isUniversityTyping[(self?.chatList.count ?? 0) - 1] = true
                    self?.phase = .success
                }.store(in: &subscripttions)
            
        case .hotplace:
            self.phase = .loading
            container.services.playService.getTopPlace()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] (topPlace) in
                    self?.isScrollType[(self?.chatList.count ?? 0) - 1] = .hotplace
                    self?.ensureDataCapacity(state: &self!.hotplaceState, index: (self?.chatList.count ?? 0) - 1)
                    self?.hotplaceState.data?[(self?.chatList.count ?? 0) - 1] = topPlace
                    self?.appendTotal("다른 대학교가 궁금하신가요? 🎓")
                    self?.isUniversityTyping[(self?.chatList.count ?? 0) - 1] = true
                    self?.phase = .success
                }.store(in: &subscripttions)
            
        case .employment:
            self.phase = .loading
            self.appendTotal("궁금하신? 대학교를 알려주세요! 🎓")
            self.isUniversityTyping[(self.chatList.count) - 1] = true
            
        case .ontime:
            self.phase = .loading
            self.appendTotal("궁금하신? 대학교를 알려주세요! 🎓")
            self.isUniversityTyping[(self.chatList.count) - 1] = true
            
        case .Occasion:
            self.phase = .loading
            self.appendTotal("궁금하신? 대학교를 알려주세요! 🎓")
            self.isUniversityTyping[(self.chatList.count) - 1] = true
            
        }
    }
    
    func subSend(action: ChatType, selectedItem: SummaryModel) {
        switch action {
        case .food:
            self.phase = .loading
            if let universityName = selectedItem.fullName {
                self.container.services.foodService.getSearchFood(universityName: universityName)
                    .sink { [weak self] completion in
                        if case .failure = completion {
                            self?.appendTotal("검색 결과를 찾을 수 없어요 😢")
                            self?.phase = .notRequested
                            self?.isUniversityTyping[(self?.chatList.count ?? 0) - 1] = false
                        }
                    } receiveValue: { [weak self] foodSearch in
                        self?.appendTotal("\(self?.universityName ?? "") 주변 맛집 정보입니다!")
                        self?.isScrollType[(self?.chatList.count ?? 0) - 1] = .food
                        self?.ensureDataCapacity(state: &self!.foodState, index: (self?.chatList.count ?? 0) - 1)
                        self?.foodState.data?[(self?.chatList.count ?? 0) - 1] = foodSearch
                        self?.appendTotal("더 자세한 정보를 알고 싶으신가요? 👀")
                        self?.phase = .success
                        self?.isUniversityTyping[(self?.chatList.count ?? 0) - 1] = true
                    }.store(in: &self.subscripttions)
            }

        case .news:
            return
        case .ranking:
            return
        case .rent:
            self.phase = .loading
            if let universityId = selectedItem.universityId {
                self.container.services.listService.getDetail(universityId: universityId)
                    .sink { [weak self] completion in
                        if case .failure = completion {
                            self?.phase = .fail
                        }
                    } receiveValue: { [weak self] universityData in
                        if let address = universityData.location {
                            if let extractAddress = self?.extractGu(from: address) {
                                self?.container.services.moneyService.getRent(CGG_NM: extractAddress, BLDG_USG: "오피스텔")
                                    .sink { [weak self] completion in
                                        if case .failure = completion {
                                            self?.phase = .fail
                                        }
                                    } receiveValue: { [weak self] response in
                                        if  let response = response.tbLnOpendataRentV?.row,
                                            let average = self?.calculateAverage(data: response) {
                                            self?.appendTotal("\(self?.universityName ?? "") 주변 월세 정보입니다!")
                                            self?.isScrollType[(self?.chatList.count ?? 0) - 1] = .rent
                                            self?.averageRent = average
                                            self?.appendTotal("더 자세한 정보를 알고 싶으신가요? 👀")
                                            self?.isUniversityTyping[(self?.chatList.count ?? 0) - 1] = true
                                            self?.phase = .success
                                        }
                                        self?.phase = .success
                                    }
                                    .store(in: &self!.subscripttions)
                            }
                        }
                    }.store(in: &self.subscripttions)
            }
        case .mou:
            return
            
        case .hotplace:
            self.phase = .loading
            if let universityId = selectedItem.universityId {
                self.container.services.playService.getSchoolPlace(universityId: universityId)
                    .sink { [weak self] completion in
                        if case .failure = completion {
                            self?.appendTotal("검색 결과를 찾을 수 없어요 😢")
                            self?.isUniversityTyping[(self?.chatList.count ?? 0) - 1] = false
                            self?.phase = .notRequested
                        }
                    } receiveValue: { [weak self] playDetail in
                        self?.appendTotal("\(self?.universityName ?? "") 주변 핫플 정보입니다!")
                        self?.isScrollType[(self?.chatList.count ?? 0) - 1] = .hotplace
                        self?.ensureDataCapacity(state: &self!.hotplaceState, index: (self?.chatList.count ?? 0) - 1)
                        self?.hotplaceState.data?[(self?.chatList.count ?? 0) - 1] = playDetail
                        self?.appendTotal("더 자세한 정보를 알고 싶으신가요? 👀")
                        self?.isUniversityTyping[(self?.chatList.count ?? 0) - 1] = true
                        self?.phase = .success
                    }.store(in: &self.subscripttions)
            }
            
        case .employment:
            self.phase = .loading
            if let universityId = selectedItem.universityId {
                self.container.services.rateService.getEmployRate(universityId: universityId)
                    .sink { [weak self] completion in
                        if case .failure = completion {
                            self?.appendTotal("검색 결과를 찾을 수 없어요 😢")
                            self?.isUniversityTyping[(self?.chatList.count ?? 0) - 1] = false
                            self?.phase = .notRequested
                        }
                    } receiveValue: { [weak self] employmentData in
                        self?.appendTotal("\(self?.universityName ?? "") 취업률 정보입니다!")
                        self?.isScrollType[(self?.chatList.count ?? 0) - 1] = .employment
                        self?.ensureDataCapacity(state: &self!.employmentState, index: (self?.chatList.count ?? 0) - 1)
                        self?.employmentState.data?[(self?.chatList.count ?? 0) - 1] = [employmentData]
                        self?.appendTotal("더 자세한 정보를 알고 싶으신가요? 👀")
                        self?.isUniversityTyping[(self?.chatList.count ?? 0) - 1] = true
                        self?.phase = .success
                    }.store(in: &self.subscripttions)
            }
            
        case .ontime:
            self.phase = .loading
            if let universityId = selectedItem.universityId {
                self.container.services.rateService.getCompetitionRate(universityId: universityId)
                    .sink { [weak self] completion in
                        if case .failure = completion {
                            self?.appendTotal("검색 결과를 찾을 수 없어요 😢")
                            self?.isUniversityTyping[(self?.chatList.count ?? 0) - 1] = false
                            self?.phase = .notRequested
                        }
                    } receiveValue: { [weak self] competitionData in
                        self?.appendTotal("\(self?.universityName ?? "") 정시 경쟁률 정보입니다!")
                        self?.isScrollType[(self?.chatList.count ?? 0) - 1] = .ontime
                        self?.ensureDataCapacity(state: &self!.ontimeState, index: (self?.chatList.count ?? 0) - 1)
                        self?.ontimeState.data?[(self?.chatList.count ?? 0) - 1] = [competitionData]
                        self?.appendTotal("더 자세한 정보를 알고 싶으신가요? 👀")
                        self?.isUniversityTyping[(self?.chatList.count ?? 0) - 1] = true
                        self?.phase = .success
                    }.store(in: &self.subscripttions)
            }
            
        case .Occasion:
            self.phase = .loading
            if let universityId = selectedItem.universityId {
                self.container.services.rateService.getCompetitionRate(universityId: universityId)
                    .sink { [weak self] completion in
                        if case .failure = completion {
                            self?.appendTotal("검색 결과를 찾을 수 없어요 😢")
                            self?.phase = .notRequested
                            self?.isUniversityTyping[(self?.chatList.count ?? 0) - 1] = false
                        }
                    } receiveValue: { [weak self] competitionData in
                        self?.appendTotal("\(self?.universityName ?? "") 수시 경쟁률 정보입니다!")
                        self?.isScrollType[(self?.chatList.count ?? 0) - 1] = .Occasion
                        self?.ensureDataCapacity(state: &self!.occasionState, index: (self?.chatList.count ?? 0) - 1)
                        self?.occasionState.data?[(self?.chatList.count ?? 0) - 1] = [competitionData]
                        self?.appendTotal("더 자세한 정보를 알고 싶으신가요? 👀")
                        self?.phase = .success
                        self?.isUniversityTyping[(self?.chatList.count ?? 0) - 1] = true
                    }.store(in: &self.subscripttions)
            }
        }
    }
    
    func search() {
        self.phase = .loading
        container.services.searchService.getSearch(searchText: universityName)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.appendTotal("검색 결과를 찾을 수 없어요 😢")
                    self?.phase = .notRequested
                    self?.isUniversityTyping[(self?.chatList.count ?? 0) - 1] = false
                }
            } receiveValue: { [weak self] searchResult in
                self?.summaryArray = searchResult
                self?.phase = .success
            }.store(in: &subscripttions)
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
        self.isScrollType.append(nil)
        self.chatList[chatList.count - 1] = string
    }
    
    func calculateDate() -> String {
        let today = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일 EEEE"
        return formatter.string(from: today)
    }
    
    func calculateAverage(data: [MoneyModel]) -> [String] {
        let totalGRFE = data.compactMap { Int($0.GRFE) }.reduce(0, +)
        let totalRTFE = data.compactMap { Int($0.RTFE) }.reduce(0, +)
        let totalAREA = data.compactMap { Int($0.RENT_AREA) }.reduce(0, +)
        
        let count = data.count
        
        let averageGRFE = count > 0 ? totalGRFE / count : 0
        let averageRTFE = count > 0 ? totalRTFE / count : 0
        let averageAREA = count > 0 ? totalAREA / count : 0
        
        return ["\(averageGRFE)", "\(averageRTFE)", "\(averageAREA)"]
    }
    
    func extractGu(from location: String) -> String? {
        let components = location.split(separator: " ")
        
        if let gu = components.first(where: { $0.hasSuffix("구") }) {
            return String(gu)
        }
        
        return nil
    }
    
}

