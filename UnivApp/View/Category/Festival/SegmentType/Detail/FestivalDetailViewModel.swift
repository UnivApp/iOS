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
        case getArtist(String, Int, Int, Int, Int)
    }
    
    @Published var phase: Phase = .notRequested
    @Published var SchoolFestivalData: [FestivalDetailModel] = [
        FestivalDetailModel(year: "2024", yearData: [
            FestivalYearData(year: "2024", name: "축제1", date: "24.09.01~24.09.3", play: "놀거리, 즐길거리, 먹을거리", lineup: [Lineup(day: "day1", detailLineup: [DetailLineup(name: "싸이", image: "")]), Lineup(day: "day2", detailLineup: [DetailLineup(name: "아이브", image: "")]), Lineup(day: "day3", detailLineup: [DetailLineup(name: "장범준", image: "")]), Lineup(day: "day4", detailLineup: [DetailLineup(name: "BTS", image: ""), DetailLineup(name: "볼빨간사춘기", image: "")])]),
            FestivalYearData(year: "2024", name: "축제2", date: "24.09.01~24.09.3", play: "놀거리, 즐길거리, 먹을거리", lineup: [Lineup(day: "day1", detailLineup: [DetailLineup(name: "윤종신", image: "")]), Lineup(day: "day2", detailLineup: [DetailLineup(name: "조정치", image: "")]), Lineup(day: "day3", detailLineup: [DetailLineup(name: "하림", image: "")]), Lineup(day: "day4", detailLineup: [DetailLineup(name: "박명수", image: ""), DetailLineup(name: "볼빨간사춘기", image: "")])])]),
        FestivalDetailModel(year: "2023", yearData: [
            FestivalYearData(year: "2023", name: "축제1", date: "24.09.01~24.09.3", play: "놀거리, 즐길거리, 먹을거리", lineup: [Lineup(day: "day1", detailLineup: [DetailLineup(name: "트와이스", image: "")]), Lineup(day: "day2", detailLineup: [DetailLineup(name: "아이브", image: "")]), Lineup(day: "day3", detailLineup: [DetailLineup(name: "임재범", image: "")]), Lineup(day: "day4", detailLineup: [DetailLineup(name: "여자친구", image: ""), DetailLineup(name: "볼빨간사춘기", image: "")])]),
            FestivalYearData(year: "2023", name: "축제2", date: "24.09.01~24.09.3", play: "놀거리, 즐길거리, 먹을거리", lineup: [Lineup(day: "day1", detailLineup: [DetailLineup(name: "르세라핌", image: "")])])]),
        
    ]
    
    private let container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
        case let .load(year):
            self.phase = .loading
            if let yearIndex = SchoolFestivalData.firstIndex(where: { $0.year == year }) {
                let yearData = SchoolFestivalData[yearIndex].yearData
                
                for (festivalIndex, festival) in yearData.enumerated() {
                    for (lineupIndex, lineup) in festival.lineup.enumerated() {
                        for (detailLineupIndex, detailLineup) in lineup.detailLineup.enumerated() {
                            let artistName = detailLineup.name
                            if detailLineup.image.isEmpty {
                                self.send(.getArtist(artistName, yearIndex, festivalIndex, lineupIndex, detailLineupIndex))
                            }
                        }
                    }
                }
                self.phase = .success
            } else {
                self.phase = .fail
            }
            
        case let .getArtist(name, yearIndex, festivalIndex, lineupIndex, detailLineupIndex):
            container.services.festivalService.getArtist(name: name)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.SchoolFestivalData[yearIndex]
                            .yearData[festivalIndex]
                            .lineup[lineupIndex]
                            .detailLineup[detailLineupIndex]
                            .image = "no"
                    }
                } receiveValue: { [weak self] artist in
                    self?.SchoolFestivalData[yearIndex]
                        .yearData[festivalIndex]
                        .lineup[lineupIndex]
                        .detailLineup[detailLineupIndex]
                        .image = artist
                }
                .store(in: &subscriptions)
        }
    }
    
    func totalLineupCount(for year: String) -> Int {
        guard let festival = SchoolFestivalData.first(where: { $0.year == year }) else { return 0 }
        return festival.yearData.reduce(0) { total, festivalYearData in
            total + festivalYearData.lineup.reduce(0) { $0 + $1.detailLineup.count }
        }
    }

}
