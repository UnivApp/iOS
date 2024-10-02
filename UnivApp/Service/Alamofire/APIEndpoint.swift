//
//  URL.swift
//  UnivApp
//
//  Created by 정성윤 on 9/9/24.
//

import Foundation

enum APIEndpoint {
    //MARK: - Auth
    case status
    case login
    case logout
    case refresh
    case withdraw
    //MARK: - List
    case summary
    case listDetail
    case search
    case addHeart
    case removeHeart
    case heartList
    //MARK: - Category
    case topPlace
    
    
    var urlString: String {
        switch self {
        case .status:
            return "http://43.200.143.28:8080/login/status"
        case .login:
            return "http://43.200.143.28:8080/login/apple"
        case .logout:
            return "http://43.200.143.28:8080/member/logout"
        case .refresh:
            return "http://43.200.143.28:8080/login/refresh"
        case .withdraw:
            return "http://43.200.143.28:8080/member/delete"
            
        case .summary:
            return "http://43.200.143.28:8080/api/universities/summary"
        case .listDetail:
            return "http://43.200.143.28:8080/api/universities/details/"
        case .search:
            return "http://43.200.143.28:8080/api/universities/search?keyword="
        case .addHeart:
            return "http://43.200.143.28:8080/api/stars/add?universityId="
        case .removeHeart:
            return "http://43.200.143.28:8080/api/stars/remove?universityId="
        case .heartList:
            return "http://43.200.143.28:8080/api/stars/list"
            
        case .topPlace:
            return "http://43.200.143.28:8080/api/activities/top-place"
        }
    }
}
