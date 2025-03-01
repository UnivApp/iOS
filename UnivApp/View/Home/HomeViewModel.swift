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

struct PosterData {
    let imageName: String
}

enum PosterType: CaseIterable {
    case food, event, rank, festival, mou, play, news
    
    var imageName: String {
        switch self {
        case .food: return "food_poster"
        case .event: return "event_poster"
        case .rank: return "rank_poster"
        case .festival: return "festival_poster"
        case .mou: return "mou_poster"
        case .play: return "play_poster"
        case .news: return "news_poster"
        }
    }
}


final class HomeViewModel: ObservableObject {
    
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
    let posterData: [PosterData]
    
    init(container: DIContainer) {
        self.container = container
        self.posterData = PosterType.allCases.map { type in
            PosterData(imageName: type.imageName)
        }
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
