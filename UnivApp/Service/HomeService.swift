//
//  HomeService.swift
//  UnivApp
//
//  Created by 정성윤 on 9/9/24.
//

import Foundation
import Combine

protocol HomeServiceType {
    
}

class HomeService: HomeServiceType {
    private var subscriptions = Set<AnyCancellable>()
    
}

class StubHomeService: HomeServiceType {
    
}
