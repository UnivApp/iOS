//
//  FoodService.swift
//  UnivApp
//
//  Created by 정성윤 on 10/8/24.
//

import Foundation
import Combine

protocol FoodServiceType {
    func getSearchFood(universityName: String) -> AnyPublisher<[FoodModel], Error>
}

final class FoodService: FoodServiceType {
    private var subscriptions = Set<AnyCancellable>()
    
    func getSearchFood(universityName: String) -> AnyPublisher<[FoodModel], any Error> {
        Future<[FoodModel], Error> { promise in
            Alamofire().getAlamofire(url: "\(APIEndpoint.food.urlString)\(universityName)")
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("학교 주변 맛집 조회 성공")
                    case let .failure(error):
                        print("학교 주변 맛집 조회 실패 \(error)")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (FoodData: [FoodModel]) in
                    guard self != nil else { return }
                    promise(.success(FoodData))
                }.store(in: &self.subscriptions)

        }.eraseToAnyPublisher()
    }
}

final class StubFoodService: FoodServiceType {
    
    func getSearchFood(universityName: String) -> AnyPublisher<[FoodModel], any Error> {
        Empty().eraseToAnyPublisher()
    }
    
}
