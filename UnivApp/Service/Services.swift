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
    var calendarService: CalendarServiceType { get set }
    var settingService: SettingServiceType { get set }
    
    var playService: PlayServiceType { get set }
    var rankingService: RankingServiceType { get set }
    var foodService: FoodServiceType { get set }
    var infoService: InfoServiceType { get set }
    var rateService: RateServiceType { get set }
    var mouService: MouServiceType { get set }
    var moneyService: MoneyServiceType { get set }
    var diagnosisService: DiagnosisServiceType { get set }
    var festivalService: FestivalServiceType { get set }
}

final class Services: ServicesType {
    var authService: AuthServiceType
    var listService: ListServiceType
    var homeService: HomeServiceType
    var searchService: SearchServiceType
    var heartService: HeartServiceType
    var playService: PlayServiceType
    var rankingService: RankingServiceType
    var foodService: FoodServiceType
    var infoService: InfoServiceType
    var rateService: RateServiceType
    var mouService: MouServiceType
    var calendarService: CalendarServiceType
    var moneyService: MoneyServiceType
    var diagnosisService: DiagnosisServiceType
    var settingService: SettingServiceType
    var festivalService: FestivalServiceType
    
    init() {
        self.authService = AuthService()
        self.listService = ListService()
        self.homeService = HomeService()
        self.searchService = SearchService()
        self.heartService = HeartService()
        self.playService = PlayService()
        self.rankingService = RankingService()
        self.foodService = FoodService()
        self.infoService = InfoService()
        self.rateService = RateService()
        self.mouService = MouService()
        self.calendarService = CalendarService()
        self.moneyService = MoneyService()
        self.diagnosisService = DiagnosisService()
        self.settingService = SettingService()
        self.festivalService = FestivalService()
    }
    
}

final class StubServices: ServicesType {
    var authService: AuthServiceType = StubAuthService()
    var listService: ListServiceType = StubListService()
    var homeService: HomeServiceType = StubHomeService()
    var searchService: SearchServiceType = StubSearchService()
    var heartService: HeartServiceType = StubHeartService()
    var playService: PlayServiceType = StubPlayService()
    var rankingService: RankingServiceType = StubRankingService()
    var foodService: FoodServiceType = StubFoodService()
    var infoService: InfoServiceType = StubInfoService()
    var rateService: RateServiceType = StubRateService()
    var mouService: MouServiceType = StubMouService()
    var calendarService: CalendarServiceType = StubCalendarService()
    var moneyService: MoneyServiceType = StubMoneyService()
    var diagnosisService: DiagnosisServiceType = StubDiagnosisService()
    var settingService: SettingServiceType = StubSettingService()
    var festivalService: FestivalServiceType = StubFestivalService()
}
