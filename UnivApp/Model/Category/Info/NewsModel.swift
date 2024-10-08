//
//  NewsModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/30/24.
//

import Foundation

struct NewsModel: Codable, Hashable {
    var newsId: Int
    var title: String
    var link: String?
    var publishedDate: String
    var admissionYear: Int
    var source: String?
}
