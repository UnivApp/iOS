//
//  NavigationRouter.swift
//  UnivApp
//
//  Created by 정성윤 on 12/7/24.
//

import Foundation
import Combine
import SwiftUI

final class NavigationRouter: ObservableObject {
    @Published var destinations: [NavigationDestination] = []
    
    func push(to view: NavigationDestination) {
        destinations.append(view)
    }
    
    func pop() {
        _ = destinations.popLast()
    }
    
    func reset() {
        destinations = []
    }
}
