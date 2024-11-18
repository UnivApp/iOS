//
//  HomeService.swift
//  UnivApp
//
//  Created by 정성윤 on 9/9/24.
//

import Foundation
import Combine

protocol HomeServiceType {
    func getTopEmployment() -> AnyPublisher<[EmploymentModel], Error>
    func getTopCompetition() -> AnyPublisher<[CompetitionModel], Error>
}

class HomeService: HomeServiceType {
    private var subscriptions = Set<AnyCancellable>()
    
    func getTopEmployment() -> AnyPublisher<[EmploymentModel], any Error> {
        Future<[EmploymentModel], Error> { promise in
            Alamofire().getAlamofire(url: APIEndpoint.topEmployment.urlString)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("탑 취업률 조회 성공")
                    case let .failure(error):
                        print("탑 취업률 조회 실패 \(error)")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (employData: [EmploymentModel]) in
                    guard self != nil else { return }
                    promise(.success(employData))
                }.store(in: &self.subscriptions)
        }.eraseToAnyPublisher()
    }
    
    func getTopCompetition() -> AnyPublisher<[CompetitionModel], any Error> {
        Future<[CompetitionModel], Error> { promise in
            Alamofire().getAlamofire(url: APIEndpoint.topCompetition.urlString)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("탑 경쟁률 조회 성공")
                    case let .failure(error):
                        print("탑 경쟁률 조회 실패 \(error)")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (competitionData: [CompetitionModel]) in
                    guard self != nil else { return }
                    promise(.success(competitionData))
                }.store(in: &self.subscriptions)
        }.eraseToAnyPublisher()
    }
}

class StubHomeService: HomeServiceType {
    
    func getTopEmployment() -> AnyPublisher<[EmploymentModel], any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func getTopCompetition() -> AnyPublisher<[CompetitionModel], any Error> {
        Empty().eraseToAnyPublisher()
    }
}
