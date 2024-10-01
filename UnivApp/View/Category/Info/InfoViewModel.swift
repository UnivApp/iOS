//
//  InfoViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//
import Foundation
import Combine

class InfoViewModel: ObservableObject {
    
    enum Action {
        
    }
    
    @Published var newsData: [NewsModel] = [
        NewsModel(title: "통합적 관점 측정...20208 수능 통사/통과 문항 공개", link: "", date: "2024-09-26", year: "2025", extract: "발췌 <EBS뉴스 2024-09-26>"),
        NewsModel(title: "통합적 관점 측정...20208 수능 통사/통과 문항 공개", link: "", date: "2024-09-26", year: "2025", extract: "발췌 <EBS뉴스 2024-09-26>"),
        NewsModel(title: "통합적 관점 측정...20208 수능 통사/통과 문항 공개", link: "", date: "2024-09-26", year: "2025", extract: "발췌 <EBS뉴스 2024-09-26>"),
        NewsModel(title: "통합적 관점 측정...20208 수능 통사/통과 문항 공개", link: "", date: "2024-09-26", year: "2025", extract: "발췌 <EBS뉴스 2024-09-26>"),
        NewsModel(title: "통합적 관점 측정...20208 수능 통사/통과 문항 공개", link: "", date: "2024-09-26", year: "2025", extract: "발췌 <EBS뉴스 2024-09-26>"),
        NewsModel(title: "통합적 관점 측정...20208 수능 통사/통과 문항 공개", link: "", date: "2024-09-26", year: "2025", extract: "발췌 <EBS뉴스 2024-09-26>"),
        NewsModel(title: "통합적 관점 측정...20208 수능 통사/통과 문항 공개", link: "", date: "2024-09-26", year: "2025", extract: "발췌 <EBS뉴스 2024-09-26>")
    ]
    
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
        ListModel(image: "emptyLogo", title: "세종대학교", heartNum: "3")
    ]
    
}

