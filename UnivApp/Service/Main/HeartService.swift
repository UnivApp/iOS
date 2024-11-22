//
//  HeartService.swift
//  UnivApp
//
//  Created by 정성윤 on 9/10/24.
//

import Foundation
import Combine

protocol HeartServiceType {
    func addHeart(universityId: Int) -> AnyPublisher<Void, Error>
    func removeHeart(universityId: Int) -> AnyPublisher<Void, Error>
    func heartList() -> AnyPublisher<[SummaryModel], Error>
}

class HeartService: HeartServiceType {
    private var subscriptions = Set<AnyCancellable>()
    
    func addHeart(universityId: Int) -> AnyPublisher<Void, any Error> {
        Future<Void, Error> { promise in
            Alamofire().nonOfZeroPost(url: "\(APIEndpoint.addHeart.urlString)\(universityId)", params: nil)
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
    
    func removeHeart(universityId: Int) -> AnyPublisher<Void, any Error> {
        Future<Void, Error> { promise in
            Alamofire().nonOfZeroPost(url: "\(APIEndpoint.removeHeart.urlString)\(universityId)", params: nil)
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
    
    func heartList() -> AnyPublisher<[SummaryModel], any Error> {
        Future<[SummaryModel], Error> { promise in
            Alamofire().getAlamofire(url: APIEndpoint.heartList.urlString)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("관심 대학 조회 성공")
                    case let .failure(error):
                        print("관심 대학 조회 실패")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (heartList: [SummaryModel]) in
                    guard self != nil else { return }
                    promise(.success(heartList))
                }.store(in: &self.subscriptions)

        }.eraseToAnyPublisher()
    }
}

class StubHeartService: HeartServiceType {
    func addHeart(universityId: Int) -> AnyPublisher<Void, any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func removeHeart(universityId: Int) -> AnyPublisher<Void, any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func heartList() -> AnyPublisher<[SummaryModel], any Error> {
        Empty().eraseToAnyPublisher()
    }
}
