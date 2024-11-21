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
        case getArtist(String, Int)
    }
    
    @Published var talentData: [TalentModel] = [TalentModel(name: "싸이", image: "", count: 12),TalentModel(name: "다비치", image: "", count: 9),TalentModel(name: "다이나믹듀오", image: "", count: 6)]
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
            for index in talentData.indices {
                self.send(action: .getArtist(talentData[index].name, index))
                self.phase = .success
            }
            
        case .detailLoad:
            self.phase = .loading
            self.phase = .success
            
        case let .getArtist(name, index):
            if let cachedImage = ImageCacheManager.shared.getImage(for: name) {
                self.talentData[index].image = cachedImage
            } else {
                container.services.festivalService.getArtist(name: name)
                    .sink { [weak self] completion in
                        if case .failure = completion {
                            self?.talentData[index].image = "no"
                        }
                    } receiveValue: { [weak self] artist in
                        ImageCacheManager.shared.setImage(artist, for: name)
                        self?.talentData[index].image = artist
                    }
                    .store(in: &subscriptions)
            }
        }
    }
}
