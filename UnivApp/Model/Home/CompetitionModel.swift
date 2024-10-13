//
//  CompetitionModel.swift
//  UnivApp
//
//  Created by 정성윤 on 10/10/24.
//

import Foundation
struct CompetitionModel: Codable, Hashable {
    var name: String
    var logo: String
    var competitionRateResponses: [HomeCompetitionRateResponses]?
}

struct HomeCompetitionRateResponses: Codable, Hashable {
    var earlyAdmissionRate: Double?
    var regularAdmissionRate: Double?
    var year: String?
    var averageAdmissionRate: Double?
}
