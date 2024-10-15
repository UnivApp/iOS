//
//  FoodViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import Foundation
import Combine

class FoodViewModel: ObservableObject {
    
    enum Action {
        case topLoad
        case detailLoad(Int)
    }
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    @Published var topFoodData: [FoodModel] = []
    @Published var schoolFoodData: [FoodModel] = []
    @Published var phase: Phase = .notRequested
    
    func send(action: Action) {
        switch action {
        case .topLoad:
            self.phase = .loading
            container.services.foodService.getTopRestaurants()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] topFoodData in
                    self?.topFoodData = topFoodData
                    self?.phase = .success
                }.store(in: &subscriptions)
        case let .detailLoad(universityId):
            self.phase = .loading
            container.services.foodService.getSchoolRestaurants(universityId: universityId)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] schoolFoodData in
                    self?.schoolFoodData = schoolFoodData
                    self?.phase = .success
                }.store(in: &subscriptions)
        }
    }
}

