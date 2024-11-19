//
//  FestivalDetailModel.swift
//  UnivApp
//
//  Created by 정성윤 on 11/18/24.
//

import Foundation

struct FestivalDetailModel: Codable, Hashable {
    var year: String
    var yearData: [FestivalYearData]
}

struct FestivalYearData: Codable, Hashable {
    var year: String
    var name: String
    var date: String
    var play: String
    var lineup: [Lineup]
}

struct Lineup: Codable, Hashable {
    var day: String
    var detailLineup: [DetailLineup]
}

struct DetailLineup: Codable, Hashable {
    var name: String
    var image: String
}
