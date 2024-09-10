//
//  HeartViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/4/24.
//

import Foundation
import Combine

class HeartViewModel: ObservableObject {
    
    enum Action {
        case load
        case addHeart(Int)
        case removeHeart(Int)
    }
    
    @Published var heartList: [SummaryModel] = []
    @Published var phase: Phase = .notRequested
    @Published var heartPhase: heartPhase = .notRequested
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .load:
            self.phase = .loading
            container.services.heartService.heartList()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .success
                        self?.heartPhase = .notRequested
                        self?.heartList = []
                    }
                } receiveValue: { [weak self] heartList in
                    self?.heartList = heartList
                    self?.phase = .success
                    self?.heartPhase = .notRequested
                }.store(in: &subscriptions)
            
        case let .addHeart(universityId):
            container.services.heartService.addHeart(universityId: universityId)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.heartPhase = .notRequested
                    }
                } receiveValue: { [weak self] addHeart in
                    self?.heartPhase = .addHeart
                }.store(in: &subscriptions)
            
        case let .removeHeart(universityId):
            container.services.heartService.removeHeart(universityId: universityId)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.heartPhase = .notRequested
                    }
                } receiveValue: { [weak self] removeHeart in
                    self?.heartPhase = .removeHeart
                }.store(in: &subscriptions)
        }
    }
}
