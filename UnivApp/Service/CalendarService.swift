//
//  CalendarService.swift
//  UnivApp
//
//  Created by 정성윤 on 10/17/24.
//

import Foundation
import Combine

protocol CalendarServiceType {
    func getTotalCalendar() -> AnyPublisher<[CalendarModel], Error>
}

class CalendarService: CalendarServiceType {
    
    private var subscriptions = Set<AnyCancellable>()
    
    func getTotalCalendar() -> AnyPublisher<[CalendarModel], any Error> {
        Future<[CalendarModel], Error> { promise in
            Alamofire().getAlamofire(url: APIEndpoint.totalCalendar.urlString)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("캘린더 전체 조회 성공")
                    case let .failure(error):
                        print("캘린더 전체 조회 실패 \(error)")
                    }
                } receiveValue: { [weak self] (calendarData: [CalendarModel]) in
                    guard self != nil else { return }
                    promise(.success(calendarData))
                }.store(in: &self.subscriptions)

        }.eraseToAnyPublisher()
    }
    
}

class StubCalendarService: CalendarServiceType {
    
    func getTotalCalendar() -> AnyPublisher<[CalendarModel], any Error> {
        Empty().eraseToAnyPublisher()
    }
    
}
