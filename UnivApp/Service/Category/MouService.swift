//
//  MouService.swift
//  UnivApp
//
//  Created by 정성윤 on 10/15/24.
//

import Foundation
import Combine

protocol MouServiceType {
    func getExpo() -> AnyPublisher<[MouModel], Error>
    func searchExpo(searchText: String) -> AnyPublisher<[MouModel], Error>
    func statusExpo(status: String) -> AnyPublisher<[MouModel], Error>
}

class MouService: MouServiceType {
    private var subscriptions = Set<AnyCancellable>()
    
    func getExpo() -> AnyPublisher<[MouModel], any Error> {
        Future<[MouModel], Error> { promise in
            Alamofire().getAlamofire(url: APIEndpoint.expo.urlString)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("연계활동 조회 성공")
                    case let .failure(error):
                        print("연계활동 조회 실패 \(error)")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (mouData: [MouModel]) in
                    guard self != nil else { return }
                    promise(.success(mouData))
                }.store(in: &self.subscriptions)

        }.eraseToAnyPublisher()
    }
    
    func searchExpo(searchText: String) -> AnyPublisher<[MouModel], any Error> {
        Future<[MouModel], Error> { promise in
            Alamofire().getAlamofire(url: "\(APIEndpoint.searchExpo.urlString)\(searchText)")
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("연계활동 검색 성공")
                    case let .failure(error):
                        print("연계활동 검색 실패 \(error)")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (mouSearchData: [MouModel]) in
                    guard self != nil else { return }
                    promise(.success(mouSearchData))
                }.store(in: &self.subscriptions)

        }.eraseToAnyPublisher()
    }
    
    func statusExpo(status: String) -> AnyPublisher<[MouModel], any Error> {
        Future<[MouModel], Error> { promise in
            Alamofire().getAlamofire(url: "\(APIEndpoint.statusExpo.urlString)\(status)")
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("연계활동 상태조회 성공")
                    case let .failure(error):
                        print("연계활동 상태조회 실패 \(error)")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (mouStatusData: [MouModel]) in
                    guard self != nil else { return }
                    promise(.success(mouStatusData))
                }.store(in: &self.subscriptions)

        }.eraseToAnyPublisher()
    }
}

class StubMouService: MouServiceType {
    
    func getExpo() -> AnyPublisher<[MouModel], any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func searchExpo(searchText: String) -> AnyPublisher<[MouModel], any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func statusExpo(status: String) -> AnyPublisher<[MouModel], any Error> {
        Empty().eraseToAnyPublisher()
    }
}
