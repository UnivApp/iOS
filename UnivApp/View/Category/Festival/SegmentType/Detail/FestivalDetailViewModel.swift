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
        case eventLoad
        case load(String)
        case getArtist(String, Int, Int, Int)
    }
    
    @Published var phase: Phase = .notRequested
    @Published var SchoolFestivalData: [FestivalYearData] = [
        FestivalYearData(eventName: "대동제", year: "2024", date: "2024.05.29 ~ 2024.05.30", dayLineup: [DayLineup(day: "Day1", lineup: [Lineup(name: "NewJeans", subname: "NewJeans", image: ""), Lineup(name: "백예슬", subname: "백예슬", image: ""), Lineup(name: "YB 윤도현밴드", subname: "YB 윤도현밴드", image: "")]), DayLineup(day: "Day2", lineup: [Lineup(name: "트리플에스", subname: "트리플에스", image: ""), Lineup(name: "로이킴", subname: "로이킴", image: "")])]),
        FestivalYearData(eventName: "청춘대로", year: "2023", date: "2024.05.29 ~ 2024.05.30", dayLineup: [DayLineup(day: "Day1", lineup: [Lineup(name: "아이브", subname: "아이브", image: ""), Lineup(name: "NewJeans", subname: "NewJeans", image: ""), Lineup(name: "YB 윤도현밴드", subname: "YB 윤도현밴드", image: "")]), DayLineup(day: "Day2", lineup: [Lineup(name: "트와이스", subname: "트와이스", image: ""), Lineup(name: "로이킴", subname: "로이킴", image: "")])])
    ]
    
    private let container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    private var imageCache = [String: String]()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
        case .eventLoad:
            //TODO: - 서버와의 연동
            self.phase = .loading
            
            self.phase = .success
            
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
                        ImageCacheManager.shared.setImage(artist, for: name)
                        self?.SchoolFestivalData[yearIndex]
                            .dayLineup[festivalIndex]
                            .lineup[lineupIndex]
                            .image = artist
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
