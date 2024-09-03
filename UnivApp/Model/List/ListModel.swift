//
//  ListModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import Foundation

struct ListModel: Hashable {
    var id = UUID()
    var image: String?
    var title: String?
    var heartNum: String?
}
