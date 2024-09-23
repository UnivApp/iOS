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
        case load
    }
    
    @Published var searchText: String
    @Published var phase: Phase = .notRequested
    @Published var hotplaceData: [PlayModel] = [
        PlayModel(title: "어린이대공원", address: "서울특별시 광진구 동일로 459", description: "🎡🐾꿀팁: 다양한 시설이 있으니 가족과 함께 방문하여 하루 종일 즐길 수 있는 프로그램을 계획해보세요!", image: "hotplace1"),
        PlayModel(title: "어린이대공원", address: "서울특별시 광진구 동일로 459", description: "🎡🐾꿀팁: 다양한 시설이 있으니 가족과 함께 방문하여 하루 종일 즐길 수 있는 프로그램을 계획해보세요!", image: "hotplace2"),
        PlayModel(title: "어린이대공원", address: "서울특별시 광진구 동일로 459", description: "🎡🐾꿀팁: 다양한 시설이 있으니 가족과 함께 방문하여 하루 종일 즐길 수 있는 프로그램을 계획해보세요!", image: "hotplace3"),
        PlayModel(title: "어린이대공원", address: "서울특별시 광진구 동일로 459", description: "🎡🐾꿀팁: 다양한 시설이 있으니 가족과 함께 방문하여 하루 종일 즐길 수 있는 프로그램을 계획해보세요!", image: "hotplace4"),
        PlayModel(title: "어린이대공원", address: "서울특별시 광진구 동일로 459", description: "🎡🐾꿀팁: 다양한 시설이 있으니 가족과 함께 방문하여 하루 종일 즐길 수 있는 프로그램을 계획해보세요!", image: "hotplace1")
    ]
    @Published var schoolList: [SummaryModel]  = [
        
    ]
    
    private var container: DIContainer
    
    init(container: DIContainer, searchText: String) {
        self.container = container
        self.searchText = searchText
    }
    
    func send(action: Action) {
        
    }
    
    var playStub: [PlayModel] = [
        PlayModel(title: "세종대학교", address: "서울특별시 광진구 동일로 459", description: "", image: "emptyLogo"),
        PlayModel(title: "세종대학교", address: "서울특별시 광진구 동일로 459", description: "", image: "emptyLogo"),
        PlayModel(title: "세종대학교", address: "서울특별시 광진구 동일로 459", description: "", image: "emptyLogo"),
        PlayModel(title: "세종대학교", address: "서울특별시 광진구 동일로 459", description: "", image: "emptyLogo"),
        PlayModel(title: "세종대학교", address: "서울특별시 광진구 동일로 459", description: "", image: "emptyLogo"),
        PlayModel(title: "세종대학교", address: "서울특별시 광진구 동일로 459", description: "", image: "emptyLogo")
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
