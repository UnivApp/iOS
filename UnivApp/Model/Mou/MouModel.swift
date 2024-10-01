//
//  MouModel.swift
//  UnivApp
//
//  Created by 정성윤 on 10/1/24.
//

import Foundation

struct MouModel: Codable, Hashable {
    var title: String
    var link: String?
    var year: String
    var category: String
    var schoolName: String
    var date: String
    var location: String
    var receipt: String
    var description: String
}
