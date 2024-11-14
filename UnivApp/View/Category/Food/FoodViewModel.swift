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
        case load(String)
    }
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    @Published var FoodData: [FoodModel] = []
    @Published var phase: Phase = .notRequested
    
    func send(action: Action) {
        switch action {
        case let .load(universityName):
            self.phase = .loading
            container.services.foodService.getSearchFood(universityName: universityName)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] FoodData in
                    self?.FoodData = FoodData
                    self?.phase = .success
                }.store(in: &subscriptions)
        }
    }
}

