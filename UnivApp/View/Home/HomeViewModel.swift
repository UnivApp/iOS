//
//  HomeViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import Foundation
import Combine
import UIKit
import SwiftUI

class HomeViewModel: ObservableObject {
    
    enum Action {
        case load
        case employLoad
        case competitionLoad
    }
    
    @Published var phase: Phase = .notRequested
    @Published var topPlaceData: [PlayModel] = []
    @Published var employmentData: [EmploymentModel] = []
    @Published var competitionData: [CompetitionModel] = []
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    let posterData: [String] = ["food_poster", "event_poster", "rank_poster", "graduate_poster", "play_poster", "news_poster"]
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .load:
            self.phase = .loading
            container.services.playService.getTopPlace()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] topPlaceData in
                    self?.topPlaceData = topPlaceData
                    self?.send(action: .employLoad)
                }.store(in: &subscriptions)
            
        case .employLoad:
            container.services.homeService.getTopEmployment()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] employData in
                    self?.employmentData = employData
                    self?.send(action: .competitionLoad)
                }.store(in: &subscriptions)
            
        case .competitionLoad:
            container.services.homeService.getTopCompetition()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] competData in
                    self?.competitionData = competData
                    self?.phase = .success
                }.store(in: &subscriptions)
        }
    }
    
    func convertToObjects(from playModels: [PlayModel]) -> [Object] {
        return playModels.map { playModel in
            if let images = playModel.images,
               let firstImage = images.compactMap({ $0?.imageUrl }).first {
                return Object(title: playModel.name, image: firstImage)
            }
            return Object(title: "", image: "")
        }
    }
}
