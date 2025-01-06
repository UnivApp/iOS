//
//  ListViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import Foundation
import Combine

final class ListViewModel: ObservableObject {
    
    enum Action {
        case load
        case search
        case addHeart(Int)
        case removeHeart(Int)
        case saveText
        case loadText
    }
    
    @Published var searchText: String
    @Published var summaryArray: [SummaryModel] = []
    @Published var phase: Phase = .notRequested
    @Published var heartPhase: heartPhase = .notRequested
    @Published var notFound: Bool = false
    @Published var showRateArray: [Bool] = []
    @Published var recentTexts: [String] = []
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer, searchText: String) {
        self.container = container
        self.searchText = searchText
    }
    
    func send(action: Action) {
        switch action {
        case .load:
            phase = .loading
            container.services.listService.getSummary()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                        self?.notFound = false
                        self?.heartPhase = .notRequested
                        self?.searchText = ""
                    }
                } receiveValue: { [weak self] summary in
                    self?.summaryArray = summary
                    self?.showRateArray = Array(repeating: false, count: summary.count)
                    self?.phase = .success
                    self?.notFound = false
                    self?.heartPhase = .notRequested
                    self?.searchText = ""
                }.store(in: &subscriptions)
            
        case .search:
            phase = .loading
            container.services.searchService.getSearch(searchText: self.searchText)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        if let searchText = self?.searchText, searchText != "" {
                            //TODO: - 최근 검색어에 겹치는게 있는지?
                            self?.recentTexts.append(searchText)
                            self?.send(action: .saveText)
                        }
                        self?.searchText = .init()
                        self?.phase = .success
                        self?.summaryArray = []
                        self?.notFound = true
                        self?.heartPhase = .notRequested
                    }
                } receiveValue: { [weak self] searchResult in
                    if let searchText = self?.searchText, searchText != "" {
                        //TODO: - 최근 검색어에 겹치는게 있는지?
                        self?.recentTexts.append(searchText)
                        self?.send(action: .saveText)
                    }
                    self?.searchText = .init()
                    self?.summaryArray = searchResult
                    self?.showRateArray = Array(repeating: false, count: searchResult.count)
                    self?.phase = .success
                    self?.notFound = false
                    self?.heartPhase = .notRequested
                }.store(in: &subscriptions)
            
        case let .addHeart(universityId):
            container.services.heartService.addHeart(universityId: universityId)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.heartPhase = .notRequested
                    }
                } receiveValue: { [weak self] addHeart in
                    self?.heartPhase = .addHeart(universityId)
                }.store(in: &subscriptions)

            
        case let .removeHeart(universityId):
            container.services.heartService.removeHeart(universityId: universityId)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.heartPhase = .notRequested
                    }
                } receiveValue: { [weak self] removeHeart in
                    self?.heartPhase = .removeHeart(universityId)
                }.store(in: &subscriptions)
            
        case .saveText:
            if recentTexts.count >= 10 {
                for removeIndex in 10..<recentTexts.count {
                    recentTexts.remove(at: removeIndex)
                }
                UserDefaults.standard.set(recentTexts, forKey: "recentTexts")
            } else {
                UserDefaults.standard.set(recentTexts, forKey: "recentTexts")
            }
        case .loadText:
            if let recentTexts = UserDefaults.standard.array(forKey: "recentTexts") as? [String] {
                print(recentTexts)
                self.recentTexts = recentTexts
            } else {
                print("recentTexts - load Error")
            }
        }
    }
}
