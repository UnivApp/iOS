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
    }
    
    @Published var searchText: String
    @Published var summaryArray: [SummaryModel] = []
    @Published var phase: Phase = .notRequested
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer, searchText: String) {
        self.container = container
        self.searchText = searchText
    }
    
    func send(action: Action) {
        switch action {
        case .load:
            container.services.listService.getSummary()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] summary in
                    self?.phase = .success
                    self?.summaryArray = summary
                }.store(in: &subscriptions)

        }
    }
}
