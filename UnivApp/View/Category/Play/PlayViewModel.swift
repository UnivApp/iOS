//
//  PlayViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import Foundation
import Combine

class PlayViewModel: ObservableObject {
    
    enum Action {
        
    }
    
    @Published var searchText: String
    
    private var container: DIContainer
    
    init(container: DIContainer, searchText: String) {
        self.container = container
        self.searchText = searchText
    }
    
    func send(action: Action) {
        
    }
    
    var playStub: [PlayModel] = [
        PlayModel(title: "세종대학교", address: "서울특별시 광진구 동일로 459", description: "", image: "Photo"),
        PlayModel(title: "세종대학교", address: "서울특별시 광진구 동일로 459", description: "", image: "Photo"),
        PlayModel(title: "세종대학교", address: "서울특별시 광진구 동일로 459", description: "", image: "Photo"),
        PlayModel(title: "세종대학교", address: "서울특별시 광진구 동일로 459", description: "", image: "Photo"),
        PlayModel(title: "세종대학교", address: "서울특별시 광진구 동일로 459", description: "", image: "Photo"),
        PlayModel(title: "세종대학교", address: "서울특별시 광진구 동일로 459", description: "", image: "Photo")
    ]
    
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
