//
//  FestivalViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 11/7/24.
//

import Foundation
import Combine

final class FestivalViewModel: ObservableObject {
    
    enum Action {
        case topLoad
        case getArtist(String, Int)
    }
    
    @Published var talentData: [TalentModel] = []
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
            container.services.festivalService.topArtists()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] artists in
                    self?.talentData = artists
                    self?.changeArtistsImage()
                }.store(in: &subscriptions)
            
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
                        if (artist != "http://i.maniadb.com") && (artist != "http://i.maniadb.com0") {
                            self?.talentData[index].image = artist
                            ImageCacheManager.shared.setImage(artist, for: name)
                        } else {
                            self?.talentData[index].image = "no"
                            ImageCacheManager.shared.setImage("no", for: name)
                        }
                    }
                    .store(in: &subscriptions)
            }
        }
    }
    
    private func changeArtistsImage() {
        for index in self.talentData.indices {
            self.send(action: .getArtist(self.talentData[index].subname, index))
            self.phase = .success
        }
    }
}
