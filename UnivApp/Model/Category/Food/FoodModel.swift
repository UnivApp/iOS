//
//  FoodModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/6/24.
//

import Foundation

struct FoodModel: Hashable, Codable {
    var name: String
    var location: String
    var placeUrl: String
    var hashtags: [String]
    var imageUrl: String?
    var topMessage: String
}
