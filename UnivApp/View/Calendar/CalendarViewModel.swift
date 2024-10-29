//
//  CalendarViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/16/24.
//

import Foundation
import Combine

struct FailAlarmModel {
    var isAlarmPhase: Bool
    var selectedType: String
}

class CalendarViewModel: ObservableObject {
    
    enum Action {
        case totalLoad
        case alarmLoad(String, Int)
        case alarmRemove(String)
    }
    
    @Published var phase: Phase = .notRequested
    @Published var calendarData: [CalendarModel] = []
    @Published var selectedCalendar: [CalendarModel] = []
    @Published var isalarmSetting: FailAlarmModel = FailAlarmModel(isAlarmPhase: false, selectedType: "")
    
    
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
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] calendarData in
                    self?.calendarData = calendarData
                    self?.phase = .success
                }.store(in: &subscriptions)
            
        case let .alarmLoad(date, id):
            self.phase = .loading
            container.services.calendarService.addAlarm(date: date, eventId: id)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.isalarmSetting = FailAlarmModel(isAlarmPhase: true, selectedType: "등록")
                    }
                } receiveValue: { [weak self]  alarmResult in
                    print(alarmResult)
                    self?.phase = .success
                }.store(in: &subscriptions)
            
        case let .alarmRemove(notificationId):
            self.phase = .loading
            container.services.calendarService.removeAlarm(notificationId: notificationId)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.isalarmSetting = FailAlarmModel(isAlarmPhase: true, selectedType: "삭제")
                    }
                } receiveValue: { [weak self] result in
                    self?.phase = .success
                }.store(in: &self.subscriptions)
        }
    }
    
    func calculatePreviousDate(from dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: dateString) else {
            print("날짜 변환에 실패했습니다.")
            return nil
        }
        
        guard let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: date) else {
            print("날짜 계산에 실패했습니다.")
            return nil
        }
        
        let previousDateString = dateFormatter.string(from: previousDate)
        return previousDateString
    }
    
}
