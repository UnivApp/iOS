//
//  EmploymentModel.swift
//  UnivApp
//
//  Created by 정성윤 on 10/10/24.
//

import Foundation
struct EmploymentModel: Codable, Hashable {
    var name: String
    var logo: String
    var employmentRateResponses: [HomeEmploymentRateResponses]?
}

struct HomeEmploymentRateResponses: Codable, Hashable {
    var year: String?
    var employmentRate: Double?
}
