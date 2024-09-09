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
    }
    
    @Published var searchText: String
    @Published var summaryArray: [SummaryModel] = []
    @Published var phase: Phase = .notRequested
    @Published var notFound: Bool = false
    
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
                    }
                } receiveValue: { [weak self] summary in
                    self?.summaryArray = summary
                    self?.phase = .success
                    self?.notFound = false
                }.store(in: &subscriptions)
        case .search:
            phase = .loading
            container.services.searchService.getSearch(searchText: self.searchText)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .success
                        self?.summaryArray = []
                        self?.notFound = true
                    }
                } receiveValue: { [weak self] searchResult in
                    self?.summaryArray = searchResult
                    self?.phase = .success
                    self?.notFound = false
                }.store(in: &subscriptions)

        }
    }
}
