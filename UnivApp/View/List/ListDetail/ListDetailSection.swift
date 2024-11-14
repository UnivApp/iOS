//
//  ListDetailSection.swift
//  UnivApp
//
//  Created by 정성윤 on 9/22/24.
//

import Foundation
enum ListDetailSection: String, CaseIterable, Hashable{
    case general = "기본정보"
    case depart = "학과목록"
    case category = "카테고리"
    
    var title: String {
        return self.rawValue
    }
}
