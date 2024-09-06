//
//  GraduateViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import Foundation
import Combine

class GraduateViewModel: ObservableObject {
    
    enum Action {
        
    }
    
    @Published var searchText: String
    
    private var container: DIContainer
    
    init(searchText: String, container: DIContainer) {
        self.searchText = searchText
        self.container = container
    }
    
    func send(action: Action) {
        
    }
    
    var stub: [FoodModel] = [
        FoodModel(title: "냉모밀", description: "시원한 수제 육수로 가슴 속 까지 시원해지는", image: "food_empty", school: "서울대학교 맛집 1위"),
        FoodModel(title: "냉모밀", description: "시원한 수제 육수로 가슴 속 까지 시원해지는", image: "food_empty", school: "서울대학교 맛집 1위"),
        FoodModel(title: "냉모밀", description: "시원한 수제 육수로 가슴 속 까지 시원해지는", image: "food_empty", school: "서울대학교 맛집 1위"),
        FoodModel(title: "냉모밀", description: "시원한 수제 육수로 가슴 속 까지 시원해지는", image: "food_empty", school: "서울대학교 맛집 1위"),
        FoodModel(title: "냉모밀", description: "시원한 수제 육수로 가슴 속 까지 시원해지는", image: "food_empty", school: "서울대학교 맛집 1위"),
        FoodModel(title: "냉모밀", description: "시원한 수제 육수로 가슴 속 까지 시원해지는", image: "food_empty", school: "서울대학교 맛집 1위")
    ]

}

