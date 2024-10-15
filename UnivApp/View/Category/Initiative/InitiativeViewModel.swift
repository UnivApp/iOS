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
        case load
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
    
    @Published var QSData: [InitiativeModel] = []
    @Published var CWURData: [InitiativeModel] = []
    @Published var ARWUData: [InitiativeModel] = []
    @Published var USNWRData: [InitiativeModel] = []
    @Published var NatureIndexData: [InitiativeModel] = []
    @Published var CWTSData: [InitiativeModel] = []
    @Published var TheData: [InitiativeModel] = []
    
    @Published var phase: Phase = .notRequested
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .load:
            self.phase = .loading
            container.services.rankingService.getRanking()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] RankingData in
                    self?.seperateData(rankingData: RankingData)
                }.store(in: &subscriptions)
        }
    }
    func seperateData(rankingData: [InitiativeModel]) {
        for index in rankingData.indices {
            switch rankingData[index].displayName {
            case "QS":
                self.QSData.append(rankingData[index])
            case "CWUR":
                self.CWURData.append(rankingData[index])
            case "ARWU":
                self.ARWUData.append(rankingData[index])
            case "USN & WR":
                self.USNWRData.append(rankingData[index])
            case "Nature Index":
                self.NatureIndexData.append(rankingData[index])
            case "CWTS":
                self.CWTSData.append(rankingData[index])
            case "THE":
                self.TheData.append(rankingData[index])
            default:
                break
            }
        }
        self.phase = .success
    }
}

