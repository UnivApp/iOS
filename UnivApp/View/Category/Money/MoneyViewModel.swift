//
//  MoneyViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//
import Foundation
import Combine
import Charts

class MoneyViewModel: ObservableObject {
    
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
    
    var stub: [ListModel] = [
        ListModel(image: "emptyLogo", title: "세종대학교", heartNum: "3"),
        ListModel(image: "emptyLogo", title: "세종대학교", heartNum: "3"),
        ListModel(image: "emptyLogo", title: "세종대학교", heartNum: "3"),
        ListModel(image: "emptyLogo", title: "세종대학교", heartNum: "3")
    ]
    
    var dataPoints: [ChartData] = [
        ChartData(label: "2020", value: 60),
        ChartData(label: "2021", value: 40),
        ChartData(label: "2022", value: 70),
        ChartData(label: "2023", value: 80),
        ChartData(label: "2024", value: 90)
    ]
    
}

