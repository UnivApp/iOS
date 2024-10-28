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
    }
    
    @Published var phase: Phase = .notRequested
    @Published var calendarData: [CalendarModel] = []
    @Published var selectedCalendar: [CalendarModel] = []
    
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

        }
    }
    
}
