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
        case load(String)
        case getArtist(String, Int, Int, Int)
    }
    
    @Published var phase: Phase = .notRequested
    @Published var SchoolFestivalData: [FestivalDetailModel] = [FestivalDetailModel(year: "2024", name: "등촌제", date: "24년 05월 09일 ~ 24년 05월 10일", play: "동아리 공연, 부스, 이벤트", lineup: [Lineup(day: "day1", detailLineup: [DetailLineup(name: "아이브", image: "")]), Lineup(day: "day2", detailLineup: [DetailLineup(name: "싸이", image: "")]), Lineup(day: "day3", detailLineup: [DetailLineup(name: "수퍼비", image: ""), DetailLineup(name: "언에듀케이티드 키드", image: "")]), Lineup(day: "day4", detailLineup: [DetailLineup(name: "윤종신", image: "")]), Lineup(day: "day5", detailLineup: [DetailLineup(name: "비투비", image: "")])]), FestivalDetailModel(year: "2023", name: "등촌제", date: "24년 05월 09일 ~ 24년 05월 10일", play: "동아리 공연, 부스, 이벤트", lineup: [Lineup(day: "day1", detailLineup: [DetailLineup(name: "경서", image: "")]), Lineup(day: "day2", detailLineup: [DetailLineup(name: "비오", image: ""), DetailLineup(name: "수퍼비", image: ""), DetailLineup(name: "언에듀케이티드 키드", image: "")])])]
    
    private let container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
        case let .load(year):
            self.phase = .loading
            if let index = SchoolFestivalData.firstIndex(where: { $0.year == year }) {
                for lineupIndex in SchoolFestivalData[index].lineup.indices {
                    for detailLineupIndex in SchoolFestivalData[index].lineup[lineupIndex].detailLineup.indices {
                        let artistName = SchoolFestivalData[index].lineup[lineupIndex].detailLineup[detailLineupIndex].name
                        if SchoolFestivalData[index].lineup[lineupIndex].detailLineup[detailLineupIndex].image.isEmpty {
                            self.send(.getArtist(artistName, index, lineupIndex, detailLineupIndex))
                        }
                    }
                }
                self.phase = .success
            } else {
                self.phase = .fail
            }
            
        case let .getArtist(name, index, lineupIndex, detailLineupIndex):
            container.services.festivalService.getArtist(name: name)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.SchoolFestivalData[index].lineup[lineupIndex].detailLineup[detailLineupIndex].image = ""
                    }
                } receiveValue: { [weak self] artist in
                    self?.SchoolFestivalData[index].lineup[lineupIndex].detailLineup[detailLineupIndex].image = artist
                }
                .store(in: &subscriptions)
        }
    }
    
    func totalLineupCount(for year: String) -> Int {
        guard let festival = SchoolFestivalData.first(where: { $0.year == year }) else { return 0 }
        return festival.lineup.reduce(0) { $0 + $1.detailLineup.count }
    }
}
