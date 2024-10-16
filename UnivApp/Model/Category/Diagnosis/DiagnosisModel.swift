//
//  DiagnosisModel.swift
//  UnivApp
//
//  Created by 정성윤 on 10/15/24.
//

import Foundation

struct DiagnosisModel: Codable, Hashable {
    var category: String?
    var question: [String]?
}

struct DiagnosisResultModel: Codable, Hashable {
    var type: String?
    var recommand: [String]?
    var description: String?
}
