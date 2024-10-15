//
//  RateViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 10/14/24.
//

import Foundation
import Combine

class RateViewModel: ObservableObject {
    
    enum Action {
        
    }
    
    private let container: DIContainer
    private let subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        
    }
}
