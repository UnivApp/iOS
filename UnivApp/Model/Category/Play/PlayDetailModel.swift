//
//  PlayDetailModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/22/24.
//

import Foundation

struct PlayDetailModel: Hashable {
    var object: [Object]
    var placeDataArray: [PlayModel]
    var placeData: PlayModel?
}
