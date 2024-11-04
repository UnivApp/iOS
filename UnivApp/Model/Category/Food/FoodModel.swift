//
//  FoodModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/6/24.
//

import Foundation

struct FoodModel: Hashable, Codable {
    var name: String
    var roadAddressName: String
    var addressName: String
    var phone: String
    var categoryName: String
    var placeUrl: String
}
