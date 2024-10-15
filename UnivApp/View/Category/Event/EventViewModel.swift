//
//  EventViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import Foundation
import Combine

class EventViewModel: ObservableObject {
    
    enum Action {
        
    }
    
    @Published var searchText: String
    
    private var container: DIContainer
    
    init(searchText: String, container: DIContainer) {
        self.searchText = searchText
        self.container = container
    }
    
    func send(action: Action) {
        
    }
    
}

