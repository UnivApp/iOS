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
    var listService: ListServiceType { get set }
    var homeService: HomeServiceType { get set }
    var searchService: SearchServiceType { get set }
}

class Services: ServicesType {
    var authService: AuthServiceType
    var listService: ListServiceType
    var homeService: HomeServiceType
    var searchService: SearchServiceType
    
    init() {
        self.authService = AuthService()
        self.listService = ListService()
        self.homeService = HomeService()
        self.searchService = SearchService()
    }
    
}

class StubServices: ServicesType {
    var authService: AuthServiceType = StubAuthService()
    var listService: ListServiceType = StubListService()
    var homeService: HomeServiceType = StubHomeService()
    var searchService: SearchServiceType = StubSearchService()
}
