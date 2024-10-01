//
//  PlayDetailModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/22/24.
//

import Foundation

struct PlayDetailModel: Codable, Hashable {
    var title: String?
    var description: String?
    var images: [String?]?
    var location: String?
    var tip: String?
}
