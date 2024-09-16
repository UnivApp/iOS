//
//  User.swift
//  UnivApp
//
//  Created by 정성윤 on 8/23/24.
//

import Foundation

struct UserModel: Codable {
    let accessToken: String?
    let accessTokenExpiresIn: Double?
    let refreshToken: String?
    let refreshTokenExpiresIn: Double?
}
