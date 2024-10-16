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
    
    init(category: String, question: [String]) {
        self.category = category
        self.question = question
    }
}

