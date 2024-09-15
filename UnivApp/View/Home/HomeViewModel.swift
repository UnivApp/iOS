//
//  HomeViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import Foundation
import Combine
import UIKit

class HomeViewModel: ObservableObject {
    
    enum Action {
        case load
    }
    
    @Published var searchText: String
    @Published var phase: Phase = .notRequested
    @Published var calendarData: [Date:UIImage] = .init() //TODO: - 캘린더 데이터
    @Published var InitiativeData: [InitiativeModel] = .init() //TODO: - 입결 데이터
    
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer, searchText: String) {
        self.container = container
        self.searchText = searchText
    }
    
    func send(action: Action) {
        switch action {
        case .load:
//            phase = .loading
            //TODO: - 캘린더 데이터 불러오기
            //TODO: - 입결 데이터 불러오기
            self.InitiativeData = [
                InitiativeModel(title: "세종대학교", logo: "emptyLogo", description: "소재: 서울 백분위(영어감점): 97.41 (0.2)", rank: 1),
                InitiativeModel(title: "세종대학교", logo: "emptyLogo", description: "소재: 서울 백분위(영어감점): 97.41 (0.2)", rank: 1),
                InitiativeModel(title: "세종대학교", logo: "emptyLogo", description: "소재: 서울 백분위(영어감점): 97.41 (0.2)", rank: 1),
                InitiativeModel(title: "세종대학교", logo: "emptyLogo", description: "소재: 서울 백분위(영어감점): 97.41 (0.2)", rank: 1),
                InitiativeModel(title: "세종대학교", logo: "emptyLogo", description: "소재: 서울 백분위(영어감점): 97.41 (0.2)", rank: 1)
            ]
        }
    }
    
}
