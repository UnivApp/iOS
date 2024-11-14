//
//  CalendarModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/16/24.
//

import Foundation

struct CalendarModel: Codable, Hashable {
    var calendarEventId: Int
    var title: String
    var date: String
    var type: String
    var notificationActive: Bool
    var notificationId: Int?
}
