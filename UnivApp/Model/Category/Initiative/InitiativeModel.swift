//
//  InitiativeModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/15/24.
//

import Foundation
import SwiftUI

struct InitiativeModel: Codable, Hashable {
    var displayName: String
    var fullName: String
    var description: String
    var year: String
    var category: String?
    var universityRankingResponses: [UniversityRankingResponses]
}

struct UniversityRankingResponses: Codable, Hashable {
    var universityName: String
    var logo: String?
    var rank: Int
}
