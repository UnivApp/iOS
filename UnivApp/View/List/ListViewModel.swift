//
//  ListViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import Foundation
import Combine

class ListViewModel: ObservableObject {
    
    enum Action {
        case load
        case search
        case addHeart(Int)
        case removeHeart(Int)
    }
    
    @Published var searchText: String
    @Published var summaryArray: [SummaryModel] = []
    @Published var phase: Phase = .notRequested
    @Published var heartPhase: heartPhase = .notRequested
    @Published var notFound: Bool = false
    @Published var showRateArray: [Bool] = []
    
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
                        self?.phase = .success
                        self?.summaryArray = []
                        self?.notFound = true
                        self?.heartPhase = .notRequested
                    }
                } receiveValue: { [weak self] searchResult in
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

        }
    }
}
