//
//  NewsModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/30/24.
//

import Foundation

struct NewsModel: Codable, Hashable {
    var title: String
    var link: String
    var date: String
    var year: String
    var extract: String
}
