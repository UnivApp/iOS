//
//  CalendarViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/16/24.
//

import Foundation
import Combine

class CalendarViewModel: ObservableObject {
    
    enum Action {
        case totalLoad
        case alarmLoad(String, Int)
        case alarmRemove(Int)
        case getAlarm
    }
    
    @Published var phase: Phase = .notRequested
    @Published var calendarData: [CalendarModel] = []
    @Published var selectedCalendar: [CalendarModel] = []
    @Published var isAlarm: Phase = .notRequested
    @Published var alarmData: [AlarmListModel] = []
    
    
    private let container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .totalLoad:
            self.phase = .loading
            container.services.calendarService.getTotalCalendar()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .success
                        //TODO: - 캘린더 전체조회 실패
                    }
                } receiveValue: { [weak self] calendarData in
                    self?.calendarData = calendarData
                    self?.phase = .success
                }.store(in: &subscriptions)
            
        case let .alarmLoad(date, id):
            self.isAlarm = .loading
            container.services.calendarService.addAlarm(date: date, eventId: id)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.isAlarm = .fail
                    }
                } receiveValue: { [weak self]  alarmResult in
                    self?.isAlarm = .success
                }.store(in: &subscriptions)
            
        case let .alarmRemove(notificationId):
            self.isAlarm = .loading
            container.services.calendarService.removeAlarm(notificationId: notificationId)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.isAlarm = .fail
                    }
                } receiveValue: { [weak self] result in
                    self?.isAlarm = .success
                }.store(in: &self.subscriptions)
            
        case .getAlarm:
            self.phase = .loading
            container.services.calendarService.getAlarm()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] alarmData in
                    self?.alarmData = alarmData
                    self?.phase = .success
                }.store(in: &subscriptions)
        }
    }
    
}
