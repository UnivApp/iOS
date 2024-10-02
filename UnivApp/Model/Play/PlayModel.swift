//
//  PlayModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import Foundation

struct PlayModel: Codable, Hashable {
    var name: String
    var description: String
    var tip: String
    var location: String
    var images: [PlayImages?]?
}

struct PlayImages: Codable, Hashable {
    var imageUrl: String?
    var source: String?
}
