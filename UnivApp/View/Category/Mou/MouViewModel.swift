//
//  MouViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import Foundation
import Combine

enum MouType: String, CaseIterable, Hashable {
    case receipt
    case nonReceipt
    
    var title: String {
        switch self {
        case .receipt:
            return "접수 중"
        case .nonReceipt:
            return "접수종료"
        }
    }
}

class MouViewModel: ObservableObject {
    
    enum Action {
        case load
        case search(String)
        case status(String)
    }
    
    @Published var MouData: [MouModel] = []
    @Published var phase: Phase = .notRequested
    @Published var textPhase: Bool = false
    @Published var searchText: String = ""
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .load:
            self.phase = .loading
            container.services.mouService.getExpo()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] mouData in
                    self?.MouData = mouData
                    self?.phase = .success
                }.store(in: &subscriptions)
            
        case let .search(searchText):
            self.phase = .loading
            container.services.mouService.searchExpo(searchText: searchText)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.textPhase = true
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] mouSearchData in
                    self?.MouData = mouSearchData
                    self?.phase = .success
                    if (self?.MouData != []) {
                        self?.textPhase = false
                    } else {
                        self?.textPhase = true
                    }
                }.store(in: &subscriptions)
            
        case let .status(status):
            self.phase = .loading
            container.services.mouService.statusExpo(status: status)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] mouStatusData in
                    self?.MouData = mouStatusData
                    self?.phase = .success
                }.store(in: &subscriptions)
        }
    }
    
}

