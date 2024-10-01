//
//  DepartModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/21/24.
//

import Foundation

struct DepartModel: Codable, Hashable {
    var title: String?
    var description: String?
    var id = UUID()
}
