//
//  HeartViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/4/24.
//

import Foundation
import Combine

class HeartViewModel: ObservableObject {
    
    enum Action {
        
    }
    
    private var container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        
    }
    
    var stub: [ListModel] = [
        ListModel(image: "emptyLogo", title: "세종대학교", heartNum: "3"),
        ListModel(image: "emptyLogo", title: "세종대학교", heartNum: "3"),
        ListModel(image: "emptyLogo", title: "세종대학교", heartNum: "3"),
        ListModel(image: "emptyLogo", title: "세종대학교", heartNum: "3"),
        ListModel(image: "emptyLogo", title: "세종대학교", heartNum: "3"),
        ListModel(image: "emptyLogo", title: "세종대학교", heartNum: "3"),
        ListModel(image: "emptyLogo", title: "세종대학교", heartNum: "3"),
        ListModel(image: "emptyLogo", title: "세종대학교", heartNum: "3"),
        ListModel(image: "emptyLogo", title: "세종대학교", heartNum: "3")
    ]
}