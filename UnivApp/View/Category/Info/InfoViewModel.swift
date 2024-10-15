//
//  InfoViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//
import Foundation
import Combine

class InfoViewModel: ObservableObject {
    
    enum Action {
        case load
    }
    
    @Published var newsData: [NewsModel] = []
    @Published var phase: Phase = .notRequested
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .load:
            self.phase = .loading
            container.services.infoService.getNewsList()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] newsData in
                    self?.newsData = newsData
                    self?.phase = .success
                }.store(in: &subscriptions)
        }
    }
    
}

