//
//  InitiativeViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//
import Foundation
import Combine

class InitiativeViewModel: ObservableObject {
    
    enum Action {
        
    }
    
    var category: [Object] = [
        Object(title: "QS 대학평가", image: "QS"),
        Object(title: "The 대학평가", image: "The"),
        Object(title: "ARWU", image: "ARWU"),
        Object(title: "CWUR", image: "CWUR"),
        Object(title: "USN & WR", image: "USNWR"),
        Object(title: "CWTS", image: "CWTS"),
        Object(title: "Nature Index", image: "NatureIndex")
    ]
    @Published var InitiativeData : [InitiativeModel] = [
        InitiativeModel(title: "세종대학교", logo: "emptyLogo", description: "소재: 서울 백분위(영어감점): 97.41 (0.2)", rank: 1),
        InitiativeModel(title: "세종대학교", logo: "emptyLogo", description: "소재: 서울 백분위(영어감점): 97.41 (0.2)", rank: 1),
        InitiativeModel(title: "세종대학교", logo: "emptyLogo", description: "소재: 서울 백분위(영어감점): 97.41 (0.2)", rank: 1),
        InitiativeModel(title: "세종대학교", logo: "emptyLogo", description: "소재: 서울 백분위(영어감점): 97.41 (0.2)", rank: 1),
        InitiativeModel(title: "세종대학교", logo: "emptyLogo", description: "소재: 서울 백분위(영어감점): 97.41 (0.2)", rank: 1)
    ]
    
    private var container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        
    }
    
}

