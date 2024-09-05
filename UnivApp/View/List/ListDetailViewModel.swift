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
        
    }
    
    private var container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        
    }
    
}
