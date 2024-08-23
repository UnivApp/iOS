//
//  Services.swift
//  UnivApp
//
//  Created by 정성윤 on 8/22/24.
//

import Foundation
import Combine

enum ServicesError: Error {
    case error(Error)
}

protocol ServicesType {
    var authService: AuthServiceType { get set }
}

class Services: ServicesType {
    var authService: AuthServiceType
    
    init(authService: AuthServiceType) {
        self.authService = AuthService()
    }
    
}

class StubServices: ServicesType {
    var authService: AuthServiceType
    
    init(authService: AuthServiceType) {
        self.authService = StubAuthService()
    }
}
