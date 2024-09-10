//
//  ListDetailViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/5/24.
//

import Foundation
import Combine

class ListDetailViewModel: ObservableObject {
    
    enum Action {
        case load(Int)
    }
    
    @Published var listDetail: ListDetailModel = ListDetailModel()
    @Published var phase: Phase = .notRequested
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case let .load(universityId):
            self.phase = .loading
            container.services.listService.getDetail(universityId: universityId)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] listDetail in
                    self?.phase = .success
                    self?.listDetail = listDetail
                }.store(in: &subscriptions)

        }
    }
    
}
