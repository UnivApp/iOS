//
//  RateService.swift
//  UnivApp
//
//  Created by 정성윤 on 10/12/24.
//

import Foundation
import Combine

protocol RateServiceType {
    func getEmployRate(universityId: Int) -> AnyPublisher<EmploymentModel, Error>
    func getCompetitionRate(universityId: Int) -> AnyPublisher<CompetitionModel, Error>
}

class RateService: RateServiceType {
    private var subscriptions = Set<AnyCancellable>()
    
    func getEmployRate(universityId: Int) -> AnyPublisher<EmploymentModel, any Error> {
        Future<EmploymentModel, Error> { promise in
            Alamofire().getAlamofire(url: "\(APIEndpoint.employment.urlString)\(universityId)")
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("취업률 조회 성공")
                    case let .failure(error):
                        print("취업률 조회 실패")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (employment: EmploymentModel) in
                    guard self != nil else { return }
                    promise(.success(employment))
                }.store(in: &self.subscriptions)
        }.eraseToAnyPublisher()
    }
    
    func getCompetitionRate(universityId: Int) -> AnyPublisher<CompetitionModel, any Error> {
        Future<CompetitionModel, Error> { promise in
            Alamofire().getAlamofire(url: "\(APIEndpoint.competition.urlString)\(universityId)")
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("경쟁률 조회 성공")
                    case let .failure(error):
                        print("경쟁률 조회 실패")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (competition: CompetitionModel) in
                    guard self != nil else { return }
                    promise(.success(competition))
                }.store(in: &self.subscriptions)
        }.eraseToAnyPublisher()
    }
}

class StubRateService: RateServiceType {
    
    func getEmployRate(universityId: Int) -> AnyPublisher<EmploymentModel, any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func getCompetitionRate(universityId: Int) -> AnyPublisher<CompetitionModel, any Error> {
        Empty().eraseToAnyPublisher()
    }
}
