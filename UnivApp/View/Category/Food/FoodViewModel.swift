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
        case load
    }
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    @Published var foodData: [FoodModel] = []
    @Published var phase: Phase = .notRequested
    
    func send(action: Action) {
        switch action {
        case .load:
            //TODO: - 음식
            return
        }
    }
}

