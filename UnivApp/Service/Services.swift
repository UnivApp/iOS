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
    var heartService: HeartServiceType { get set }
    var playService: PlayServiceType { get set }
}

class Services: ServicesType {
    var authService: AuthServiceType
    var listService: ListServiceType
    var homeService: HomeServiceType
    var searchService: SearchServiceType
    var heartService: HeartServiceType
    var playService: PlayServiceType
    
    init() {
        self.authService = AuthService()
        self.listService = ListService()
        self.homeService = HomeService()
        self.searchService = SearchService()
        self.heartService = HeartService()
        self.playService = PlayService()
    }
    
}

class StubServices: ServicesType {
    var authService: AuthServiceType = StubAuthService()
    var listService: ListServiceType = StubListService()
    var homeService: HomeServiceType = StubHomeService()
    var searchService: SearchServiceType = StubSearchService()
    var heartService: HeartServiceType = StubHeartService()
    var playService: PlayServiceType = StubPlayService()
}
