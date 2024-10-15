//
//  RateDetailViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 10/14/24.
//

import Foundation
import Combine

class RateDetailViewModel: ObservableObject {
    
    enum Action {
        case employLoad(Int)
        case competitionLoad(Int)
    }
    
    private let container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var phase: Phase = .notRequested
    @Published var universityID: [Int] = []
    @Published var employmentData: EmploymentModel = .init()
    @Published var competitionData: CompetitionModel = .init()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case let .employLoad(id):
            self.phase = .loading
            self.employmentData = .init()
            container.services.rateService.getEmployRate(universityId: id)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] employData in
                    self?.employmentData = employData
                    self?.phase = .success
                }.store(in: &subscriptions)
        case let .competitionLoad(id):
            self.competitionData = .init()
            container.services.rateService.getCompetitionRate(universityId: id)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] competitionData in
                    self?.competitionData = (competitionData)
                    self?.phase = .success
                }.store(in: &subscriptions)
        }
    }
    
}
