//
//  DIContainer.swift
//  UnivApp
//
//  Created by 정성윤 on 8/22/24.
//

import Foundation
import Combine

class DIContainer: ObservableObject {
    
    var services: ServicesType
    
    init(services: ServicesType) {
        self.services = services
    }
    
}
