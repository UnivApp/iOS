//
//  TimeTableViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 3/17/25.
//

import SwiftUI
import Combine

//TODO: Entity
struct Schedule: Identifiable {
    let id = UUID()
    var name: String
    var color: Color
    var days: [String]
    var time: String
}

final class TimeTableViewModel: ObservableObject {
    enum Action {
        case addSchedule
        case togglePopup(Bool)
    }
    
    @Published var phase: Phase = .notRequested
    @Published var schedules: [Schedule] = []
    @Published var showPopup: Bool = false
    
    private var subscriptions = Set<AnyCancellable>()
    private let days = ["월", "화", "수", "목", "금", "토", "일"]
    
    func addSchedule(name: String, day: String, hour: Int, color: Color) {
        let newSchedule = Schedule(name: name, color: color, days: [day], time: "\(hour)")
        schedules.append(newSchedule)
        showPopup = false
    }
    
    func sendAction(_ action: Action) {
        switch action {
        case .addSchedule:
            showPopup = true
        case .togglePopup(let isVisible):
            showPopup = isVisible
        }
    }
}
