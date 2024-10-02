//
//  PlayService.swift
//  UnivApp
//
//  Created by 정성윤 on 10/2/24.
//

import Foundation
import Combine

protocol PlayServiceType {
    func getTopPlace() -> AnyPublisher<[PlayModel], Error>
}

class PlayService: PlayServiceType {
    private var subscriptions = Set<AnyCancellable>()
    
    func getTopPlace() -> AnyPublisher<[PlayModel], any Error> {
        Future<[PlayModel], Error> { promise in
            Alamofire().getAlamofire(url: APIEndpoint.topPlace.urlString)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("탑플레이스 정보 조회 성공")
                    case let .failure(error):
                        print("탑플레이스 정보 조회 실패 \(error)")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (topplaceData: [PlayModel]) in
                    guard self != nil else { return }
                    promise(.success(topplaceData))
                }.store(in: &self.subscriptions)
        }.eraseToAnyPublisher()
    }
}

class StubPlayService: PlayServiceType {
    func getTopPlace() -> AnyPublisher<[PlayModel], any Error> {
        Empty().eraseToAnyPublisher()
    }
}
