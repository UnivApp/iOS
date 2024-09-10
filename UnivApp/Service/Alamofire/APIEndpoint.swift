//
//  URL.swift
//  UnivApp
//
//  Created by 정성윤 on 9/9/24.
//

import Foundation

enum APIEndpoint {
    case status
    case login
    case logout
    case refresh(refreshToken: String)
    case withdraw
    
    case summary
    case banners
    case scoreImage
    case search
    case addHeart
    case removeHeart
    
    
    var urlString: String {
        switch self {
        case .status:
            return "http://43.200.143.28:8080/login/status"
        case .login:
            return "http://43.200.143.28:8080/login/apple"
        case .logout:
            return "http://43.200.143.28:8080/member/logout"
        case .refresh(let refreshToken):
            return ""
        case .withdraw:
            return "http://43.200.143.28:8080/member/delete"
            
        case .summary:
            return "http://43.200.143.28:8080/api/universities/summary"
        case .banners:
            return "http://43.200.143.28:8080/api/banners"
        case .scoreImage:
            return "http://43.200.143.28:8080/api/entrance-score-images"
        case .search:
            return "http://43.200.143.28:8080/api/universities/search?keyword="
        case .addHeart:
            return "http://43.200.143.28:8080/api/stars/add?universityId="
        case .removeHeart:
            return "http://43.200.143.28:8080/api/stars/remove?universityId="
        }
    }
}
