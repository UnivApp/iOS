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
    func removeAlarm(notificationId: Int) -> AnyPublisher<Void, Error>
    func getAlarm() -> AnyPublisher<[AlarmListModel], Error>
}

class CalendarService: CalendarServiceType {
    
    init() {
        NotificationCenter.default.publisher(for: .deviceTokenDidSave)
            .sink { [weak self] _ in
                self?.fetchDeviceToken()
            }
            .store(in: &subscriptions)
    }
    
    private var deviceToken: String?
    
    private func fetchDeviceToken() {
        self.deviceToken = KeychainWrapper.standard.string(forKey: "DeviceToken")
    }
    
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
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (calendarData: [CalendarModel]) in
                    guard self != nil else { return }
                    promise(.success(calendarData))
                }.store(in: &self.subscriptions)

        }.eraseToAnyPublisher()
    }
    
    func addAlarm(date: String, eventId: Int) -> AnyPublisher<AddAlarmModel, any Error> {
        Future<AddAlarmModel, Error> { promise in
            guard let token = self.deviceToken else {
                promise(.failure(DeviceTokenError.deviceTokenNotFound))
                return
            }
            let params: [String: Any] = [
                "registrationTokens": [token],
                "notificationDate": date,
                "eventId": eventId
            ]
            Alamofire().postAlamofire(url: APIEndpoint.addAlarm.urlString, params: params)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("알림 설정 성공")
                    case let .failure(error):
                        print("알림 설정 실패 \(error)")
                        promise(.failure(error))
                    }
                }, receiveValue: { result in
                    promise(.success(result))
                }).store(in: &self.subscriptions)
        }.eraseToAnyPublisher()
    }
    
    func removeAlarm(notificationId: Int) -> AnyPublisher<Void, any Error> {
        Future<Void, Error> { promise in
            Alamofire().delete(url: "\(APIEndpoint.removeAlarm.urlString)\(notificationId)")
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
    
    func getAlarm() -> AnyPublisher<[AlarmListModel], any Error> {
        Future<[AlarmListModel], Error> { promise in
            Alamofire().getAlamofire(url: APIEndpoint.getAlarm.urlString)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("알림 조회 성공")
                    case let .failure(error):
                        print("알림 조회 실패 \(error)")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (result: [AlarmListModel]) in
                    guard self != nil else { return }
                    promise(.success(result))
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
    
    func removeAlarm(notificationId: Int) -> AnyPublisher<Void, any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func getAlarm() -> AnyPublisher<[AlarmListModel], any Error> {
        Empty().eraseToAnyPublisher()
    }
    
}
