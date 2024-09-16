//
//  CalendarViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/16/24.
//

import Foundation
import Combine

class CalendarViewModel: ObservableObject {
    
    @Published var phase: Phase = .notRequested
    @Published var calendarData: [CalendarModel] = [
        CalendarModel(title: "오늘의 일정", description: "오늘의 일정", image: "nil", date: "2024-09-17"),
        CalendarModel(title: "오늘의 일정", description: "오늘의 일정", image: "nil", date: "2024-09-17"),
        CalendarModel(title: "오늘의 일정", description: "오늘의 일정", image: "nil", date: "2024-09-17"),
        CalendarModel(title: "오늘의 일정", description: "오늘의 일정", image: "nil", date: "2024-09-17"),
        CalendarModel(title: "오늘의 일정", description: "오늘의 일정", image: "nil", date: "2024-09-17"),
        CalendarModel(title: "오늘의 일정", description: "오늘의 일정", image: "nil", date: "2024-09-17"),
        CalendarModel(title: "오늘의 일정", description: "오늘의 일정", image: "nil", date: "2024-09-17")
    ]
    
}
