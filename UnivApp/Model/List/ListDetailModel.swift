//
//  ListDetailModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/10/24.
//

import Foundation

struct ListDetailModel: Codable {
    var universityId : Int?
    var fullName: String?
    var location: String?
    var type: String?
    var logo: String?
    var phoneNumber: String?
    var website: String?
    var admissionSite: String?
    var starNum: Int?
}
