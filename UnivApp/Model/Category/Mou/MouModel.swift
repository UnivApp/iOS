//
//  MouModel.swift
//  UnivApp
//
//  Created by 정성윤 on 10/1/24.
//

import Foundation

struct MouModel: Codable, Hashable {
    var expoId: Int
    var title: String
    var category: String
    var expoYear: String
    var status: String
    var link: String?
    var location: String
    var content: String
    var date: String
}
