//
//  User.swift
//  UnivApp
//
//  Created by 정성윤 on 8/23/24.
//

import Foundation

struct UserModel: Codable {
    let accessToken: String?
    let refreshToken: String?
    let existingMember: Bool?
}

struct AuthStateModel: Codable {
    let message: String
    let nicknameSet: Bool
    let loggedIn: Bool
}
