//
//  FestivalDetailViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 11/18/24.
//

import Foundation
import Combine

class FestivalDetailViewModel: ObservableObject {
    
    enum Action {
        case eventLoad(String)
        case load(String)
        case getArtist(String, Int, Int, Int)
    }
    
    @Published var phase: Phase = .notRequested
    @Published var SchoolFestivalData: [FestivalYearData] = []
    @Published var isReady: Bool = false
    
    private let container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    private var imageCache = [String: String]()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
        case let .eventLoad(universityId):
            self.phase = .loading
            container.services.festivalService.getFestival(universityId: universityId)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] festivalData in
                    if festivalData.events.isEmpty {
                        self?.isReady = true
                    } else {
                        self?.isReady = false
                        self?.SchoolFestivalData = festivalData.events
                    }
                    self?.phase = .success
                }.store(in: &subscriptions)
            
        case let .load(eventName):
            self.phase = .loading
            if let eventIndex = SchoolFestivalData.firstIndex(where: { "\($0.year)년 \($0.eventName)" == eventName }) {
                let eventData = SchoolFestivalData[eventIndex].dayLineup
                
                for (festivalIndex, festival) in eventData.enumerated() {
                    for (lineupIndex, lineup) in festival.lineup.enumerated() {
                        let artistName = lineup.subname
                        if lineup.image.isEmpty {
                            self.send(.getArtist(artistName, eventIndex, festivalIndex, lineupIndex))
                        }
                    }
                }
                self.phase = .success
            } else {
                self.phase = .fail
            }
            
        case let .getArtist(name, yearIndex, festivalIndex, lineupIndex):
            if let cachedImage = ImageCacheManager.shared.getImage(for: name) {
                self.SchoolFestivalData[yearIndex]
                    .dayLineup[festivalIndex]
                    .lineup[lineupIndex]
                    .image = cachedImage
            } else {
                container.services.festivalService.getArtist(name: name)
                    .sink { [weak self] completion in
                        if case .failure = completion {
                            self?.SchoolFestivalData[yearIndex]
                                .dayLineup[festivalIndex]
                                .lineup[lineupIndex]
                                .image = "no"
                        }
                    } receiveValue: { [weak self] artist in
                        if (artist != "http://i.maniadb.com") && (artist != "http://i.maniadb.com0") {
                            self?.SchoolFestivalData[yearIndex]
                                .dayLineup[festivalIndex]
                                .lineup[lineupIndex]
                                .image = artist
                            ImageCacheManager.shared.setImage(artist, for: name)
                        } else {
                            self?.SchoolFestivalData[yearIndex]
                                .dayLineup[festivalIndex]
                                .lineup[lineupIndex]
                                .image = "no"
                            ImageCacheManager.shared.setImage("no", for: name)
                        }
                    }
                    .store(in: &subscriptions)
            }
        }
    }
    
    func totalLineupCount(for year: String) -> Int {
        guard let festival = SchoolFestivalData.first(where: { $0.year == year }) else { return 0 }
        return festival.dayLineup.reduce(0) { total, festivalYearData in
            total + festivalYearData.lineup.reduce(0) { $0 + $1.image.count }
        }
    }

}
