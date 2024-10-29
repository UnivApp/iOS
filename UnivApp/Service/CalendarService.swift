//
//  CalendarService.swift
//  UnivApp
//
//  Created by 정성윤 on 10/17/24.
//

import Foundation
import Combine
import SwiftKeychainWrapper

enum DeviceTokenError: Error {
    case deviceTokenNotFound
}

protocol CalendarServiceType {
    func getTotalCalendar() -> AnyPublisher<[CalendarModel], Error>
    func addAlarm(date: String, eventId: Int) -> AnyPublisher<AddAlarmModel, Error>
    func removeAlarm(notificationId: String) -> AnyPublisher<Void, Error>
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
    
    func addAlarm(date: String, eventId: Int) -> AnyPublisher<AddAlarmModel, any Error> {
        Future<AddAlarmModel, Error> { promise in
            if let deviceToken = KeychainWrapper.standard.string(forKey: "DeviceToken") {
                let params: [String:Any] = [
                    "registrationTokens": [deviceToken],
                    "notificationDate": date,
                    "eventId": eventId
                ]
                Alamofire().postAlamofire(url: APIEndpoint.addAlarm.urlString, params: params)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            print("알림 설정 성공")
                        case let .failure(error):
                            print("알림 설정 실패 \(error)")
                            promise(.failure(error))
                        }
                    } receiveValue: { [weak self] (result: AddAlarmModel) in
                        guard self != nil else { return }
                        promise(.success(result))
                    }.store(in: &self.subscriptions)
            } else {
                promise(.failure(DeviceTokenError.deviceTokenNotFound))
            }
        }.eraseToAnyPublisher()
    }
    
    func removeAlarm(notificationId: String) -> AnyPublisher<Void, any Error> {
        Future<Void, Error> { promise in
            Alamofire().delete(url: APIEndpoint.removeAlarm.urlString)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("알림 삭제 성공")
                    case let .failure(error):
                        print("알림 삭제 실패 \(error)")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (result: Void) in
                    guard self != nil else { return }
                    promise(.success(()))
                }.store(in: &self.subscriptions)

        }.eraseToAnyPublisher()
    }
}

class StubCalendarService: CalendarServiceType {
    
    func getTotalCalendar() -> AnyPublisher<[CalendarModel], any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func addAlarm(date: String, eventId: Int) -> AnyPublisher<AddAlarmModel, any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func removeAlarm(notificationId: String) -> AnyPublisher<Void, any Error> {
        Empty().eraseToAnyPublisher()
    }
    
}
