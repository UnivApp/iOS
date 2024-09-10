//
//  SettingViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/10/24.
//

import Foundation
import Combine

class SettingViewModel: ObservableObject {
    
    enum Action {
        case load
    }
    
    @Published var phase: Phase = .notRequested
    
    private let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .load:
            self.phase = .success
        }
    }
    
}
