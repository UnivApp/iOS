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
    case schoolPlace
    case ranking
    case schoolFood
    case topFood
    case news
    case expo
    case searchExpo
    case statusExpo
    case rent
    case diagnosisQuestion
    case diagnosisResult
    //MARK: - Home
    case topEmployment
    case topCompetition
    case employment
    case competition
    //MARK: - Calendar
    case totalCalendar
    
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
        case .schoolPlace:
            return "http://43.200.143.28:8080/api/activities?universityId="
        case .ranking:
            return "http://43.200.143.28:8080/api/rankings"
        case .schoolFood:
            return "http://43.200.143.28:8080/api/restaurants?universityId="
        case .topFood:
            return "http://43.200.143.28:8080/api/restaurants/top"
        case .news:
            return "http://43.200.143.28:8080/api/news"
        case .expo:
            return "http://43.200.143.28:8080/api/expo"
        case .searchExpo:
            return "http://43.200.143.28:8080/api/expo/search?keyword="
        case .statusExpo:
            return "http://43.200.143.28:8080/api/expo/status?status="
        case .rent:
            return "http://openapi.seoul.go.kr:8088/\(OpenApiKey)/json/tbLnOpendataRentV/1/50/2024/ /"
        case .diagnosisQuestion:
            return "http://43.200.143.28:8080/api/questionnaires"
        case .diagnosisResult:
            return "http://43.200.143.28:8080/api/questionnaires/results?score="
        
        case .topEmployment:
            return "http://43.200.143.28:8080/api/employment-rate/top-5"
        case .topCompetition:
            return "http://43.200.143.28:8080/api/competition-rate/top-5"
        case .employment:
            return "http://43.200.143.28:8080/api/employment-rate?universityId="
        case .competition:
            return "http://43.200.143.28:8080/api/competition-rate?universityId="
            
        case .totalCalendar:
            return "http://43.200.143.28:8080/api/calendar-events"
        }
    }
}
