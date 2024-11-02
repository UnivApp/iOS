//
//  AlarmModel.swift
//  UnivApp
//
//  Created by 정성윤 on 10/28/24.
//

import Foundation

struct AddAlarmModel: Codable {
    var notificationId: Int
    var notificationDate: String
    var eventId: Int
    var registrationTokens: [String]
    var active: Bool
}

struct AlarmListModel: Codable {
    let notificationId: Int
    let title: String
    let type: String
    let notificationDate: String
    let eventId: Int
    let registrationTokens: [String]
    let active: Bool
}
