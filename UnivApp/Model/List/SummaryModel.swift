//
//  SummaryModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/9/24.
//

import Foundation

struct SummaryModel: Codable {
    let universityId: Int?
    let fullName: String?
    let logo: String?
    let starNum: Int?
    let starred: Bool?
}
