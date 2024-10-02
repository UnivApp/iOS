//
//  PlayViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import Foundation
import Combine

class PlayViewModel: ObservableObject {
    
    enum Action {
        case topPlaceLoad
    }
    
    @Published var phase: Phase = .notRequested
    @Published var topPlaceData: [PlayModel] = []
    @Published var data: [PlayDetailModel] = []
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .topPlaceLoad:
            self.phase = .loading
            container.services.playService.getTopPlace()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] topPlaceData in
                    self?.topPlaceData = topPlaceData
                    self?.phase = .success
                }.store(in: &subscriptions)
        }
    }
    
}
