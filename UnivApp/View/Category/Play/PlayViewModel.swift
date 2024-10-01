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
    @Published var data: [PlayDetailModel] =
    [
        PlayDetailModel(title: "어린이대공원", description: "특징: 세종대학교 정문 바로 건너편에 위치해 있어 접근성이 뛰어납니다. 무료로 입장할 수 있으며, 놀이공원, 동물원, 식물원, 음악 분수 등 다양한 시설이 마련되어 있습니다. 특히 세종대 학생들이 공강 시간에 가볍게 산책하기 위해 자주 찾는 장소입니다. 놀이기구는 별도의 요금을 지불하고 이용할 수 있습니다.", images: ["hotplace1", "hotplace2", "hotplace3", "hotplace4", "hotplace4"], location: "위치: 서울 광진구 능동로 216", tip: "🎡🐾꿀팁: 다양한 시설이 있으니 가족과 함께 방문하여 하루 종일 즐길 수 있는 프로그램을 계획해보세요!"),
        PlayDetailModel(title: "어린이대공원", description: "특징: 세종대학교 정문 바로 건너편에 위치해 있어 접근성이 뛰어납니다. 무료로 입장할 수 있으며, 놀이공원, 동물원, 식물원, 음악 분수 등 다양한 시설이 마련되어 있습니다. 특히 세종대 학생들이 공강 시간에 가볍게 산책하기 위해 자주 찾는 장소입니다. 놀이기구는 별도의 요금을 지불하고 이용할 수 있습니다.", images: ["hotplace1", "hotplace2", "hotplace1", "hotplace2"], location: "위치: 서울 광진구 능동로 216", tip: "🎡🐾꿀팁: 다양한 시설이 있으니 가족과 함께 방문하여 하루 종일 즐길 수 있는 프로그램을 계획해보세요!"),
        PlayDetailModel(title: "어린이대공원", description: "특징: 세종대학교 정문 바로 건너편에 위치해 있어 접근성이 뛰어납니다. 무료로 입장할 수 있으며, 놀이공원, 동물원, 식물원, 음악 분수 등 다양한 시설이 마련되어 있습니다. 특히 세종대 학생들이 공강 시간에 가볍게 산책하기 위해 자주 찾는 장소입니다. 놀이기구는 별도의 요금을 지불하고 이용할 수 있습니다.", images: ["hotplace1", "hotplace3", "hotplace4", "hotplace2"], location: "위치: 서울 광진구 능동로 216", tip: "🎡🐾꿀팁: 다양한 시설이 있으니 가족과 함께 방문하여 하루 종일 즐길 수 있는 프로그램을 계획해보세요!"),
        PlayDetailModel(title: "어린이대공원", description: "특징: 세종대학교 정문 바로 건너편에 위치해 있어 접근성이 뛰어납니다. 무료로 입장할 수 있으며, 놀이공원, 동물원, 식물원, 음악 분수 등 다양한 시설이 마련되어 있습니다. 특히 세종대 학생들이 공강 시간에 가볍게 산책하기 위해 자주 찾는 장소입니다. 놀이기구는 별도의 요금을 지불하고 이용할 수 있습니다.", images: ["hotplace4", "hotplace2", "hotplace4", "hotplace1"], location: "위치: 서울 광진구 능동로 216", tip: "🎡🐾꿀팁: 다양한 시설이 있으니 가족과 함께 방문하여 하루 종일 즐길 수 있는 프로그램을 계획해보세요!")
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
