//
//  FestivalViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 11/7/24.
//

import Foundation
import Combine

class FestivalViewModel: ObservableObject {
    
    enum Action {
        case topLoad
        case detailLoad
    }
    
    @Published var talentData: [TalentModel] = [TalentModel(name: "싸이", image: "", count: 12),TalentModel(name: "다비치", image: "", count: 9),TalentModel(name: "다니아믹듀오", image: "", count: 6),TalentModel(name: "싸이", image: "", count: 78)]
    @Published var festivalData: [FestivalModel] = []
    @Published var phase: Phase = .notRequested
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .topLoad:
            self.phase = .loading
            self.phase = .success
            return
        case .detailLoad:
            self.phase = .loading
            self.phase = .success
            return
        }
    }
}