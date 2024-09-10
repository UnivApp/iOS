//
//  HeartService.swift
//  UnivApp
//
//  Created by 정성윤 on 9/10/24.
//

import Foundation
import Combine

protocol HeartServiceType {
    func addHeart(universityName: String) -> AnyPublisher<Void, Error>
    func removeHeart(universityName: String) -> AnyPublisher<Void, Error>
}

class HeartService: HeartServiceType {
    private var subscriptions = Set<AnyCancellable>()
    
    func addHeart(universityName: String) -> AnyPublisher<Void, any Error> {
        Future<Void, Error> { promise in
            Alamofire().heartAlamofire(url: "\(APIEndpoint.addHeart.urlString)\(universityName)", params: nil)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("관심 대학 등록 성공")
                    case let .failure(error):
                        print("관심 대학 등록 실패 \(error)")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (addHeart: Void) in
                    guard self != nil else { return }
                    promise(.success(()))
                }.store(in: &self.subscriptions)

        }.eraseToAnyPublisher()
    }
    
    func removeHeart(universityName: String) -> AnyPublisher<Void, any Error> {
        Future<Void, Error> { promise in
            Alamofire().heartAlamofire(url: "\(APIEndpoint.removeHeart.urlString)\(universityName)", params: nil)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("관심 대학 삭제 성공")
                    case let .failure(error):
                        print("관심 대학 삭제 실패 \(error)")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (removeHeart: Void) in
                    guard self != nil else { return }
                    promise(.success(()))
                }.store(in: &self.subscriptions)

        }.eraseToAnyPublisher()
    }
}

class StubHeartService: HeartServiceType {
    func addHeart(universityName: String) -> AnyPublisher<Void, any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func removeHeart(universityName: String) -> AnyPublisher<Void, any Error> {
        Empty().eraseToAnyPublisher()
    }
}
