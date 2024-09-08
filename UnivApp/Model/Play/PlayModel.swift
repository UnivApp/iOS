//
//  PlayModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import Foundation

struct PlayModel: Hashable {
    var id = UUID()
    var title: String?
    var address: String?
    var description: String?
    var image: String?
}
