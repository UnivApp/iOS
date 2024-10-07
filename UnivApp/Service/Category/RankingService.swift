//
//  RankingService.swift
//  UnivApp
//
//  Created by 정성윤 on 10/7/24.
//

import Foundation
import Combine

protocol RankingServiceType {
    func getRanking() -> AnyPublisher<[InitiativeModel], Error>
}

class RankingService: RankingServiceType {
    private var subscriptions = Set<AnyCancellable>()
    
    func getRanking() -> AnyPublisher<[InitiativeModel], any Error> {
        Future<[InitiativeModel], Error> { promise in
            Alamofire().getAlamofire(url: APIEndpoint.ranking.urlString)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("랭킹 조회 성공")
                    case let .failure(error):
                        print("랭킹 조회 실패")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (rankingData: [InitiativeModel]) in
                    guard self != nil else { return }
                    promise(.success(rankingData))
                }.store(in: &self.subscriptions)
        }
        .eraseToAnyPublisher()
    }
}

class StubRankingService: RankingServiceType {
    func getRanking() -> AnyPublisher<[InitiativeModel], any Error> {
        Empty().eraseToAnyPublisher()
    }
}
