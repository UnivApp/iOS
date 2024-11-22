//
//  FestivalDetailModel.swift
//  UnivApp
//
//  Created by 정성윤 on 11/18/24.
//

import Foundation

struct FestivalDetailModel: Codable, Hashable {
    var universityId: Int
    var universityName: String
    var events: [FestivalYearData]
}

struct FestivalYearData: Codable, Hashable {
    var eventName: String
    var year: String
    var date: String
    var dayLineup: [DayLineup]
}

struct DayLineup: Codable, Hashable {
    var day: String
    var lineup: [Lineup]
}

struct Lineup: Codable, Hashable {
    var name: String
    var subname: String
    var image: String
}
