//
//  Phase.swift
//  UnivApp
//
//  Created by 정성윤 on 9/9/24.
//

import Foundation
enum Phase {
    case notRequested
    case loading
    case success
    case fail
}

enum heartPhase: Equatable {
    case notRequested
    case addHeart(Int)
    case removeHeart(Int)
}
