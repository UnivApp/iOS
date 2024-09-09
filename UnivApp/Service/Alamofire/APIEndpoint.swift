//
//  URL.swift
//  UnivApp
//
//  Created by 정성윤 on 9/9/24.
//

import Foundation

enum APIEndpoint {
    case login
    case refresh(refreshToken: String)
    case summary
    
    var urlString: String {
        switch self {
        case .login:
            return "http://43.200.143.28:8080/login/apple"
        case .refresh(let refreshToken):
            return ""
        case .summary:
            return "http://43.200.143.28:8080/api/universities/summary"
        }
    }
}
