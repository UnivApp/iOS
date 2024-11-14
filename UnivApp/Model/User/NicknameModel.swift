//
//  NicknameModel.swift
//  UnivApp
//
//  Created by 정성윤 on 11/1/24.
//

import Foundation

struct NicknameModel: Codable {
    var nickName: String
}

struct CheckNicknameModel: Codable {
    var message: String
    var duplicate: Bool
}
