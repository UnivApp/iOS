//
//  MoneyService.swift
//  UnivApp
//
//  Created by 정성윤 on 10/18/24.
//

import Foundation
import Combine

protocol MoneyServiceType {
    func getRent(CGG_NM: String, BLDG_USG: String) -> AnyPublisher<RentModel, Error>
}

class MoneyService: MoneyServiceType {
    
    private var subscriptioins = Set<AnyCancellable>()
    
    func getRent(CGG_NM: String, BLDG_USG: String) -> AnyPublisher<RentModel, any Error> {
        Future<RentModel, Error> { promise in
            var endPointUrl = "\(APIEndpoint.rent.urlString) / / / / / / /\(BLDG_USG)"
            if CGG_NM != "" {
                endPointUrl = "\(APIEndpoint.rent.urlString)\(CGG_NM)/ / / / / / /\(BLDG_USG)"
            }
            Alamofire().getAlamofire(url: endPointUrl)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("월세 데이터 조회 성공")
                    case let .failure(error):
                        print("월세 데이터 조회 실패 \(error)")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (rentData: RentModel) in
                    guard self != nil else { return }
                    promise(.success(rentData))
                }.store(in: &self.subscriptioins)
        }.eraseToAnyPublisher()
    }
}

class StubMoneyService: MoneyServiceType {
    
    func getRent(CGG_NM: String, BLDG_USG: String) -> AnyPublisher<RentModel, any Error> {
        Empty().eraseToAnyPublisher()
    }
    
}
