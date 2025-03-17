//
//  HomeViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 3/17/25.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    enum Action {
        
    }
    
    @Published var phase: Phase = .notRequested
    private var subscriptions = Set<AnyCancellable>()
    
    func sendAction(_ action: Action) {
        
    }
    
}
