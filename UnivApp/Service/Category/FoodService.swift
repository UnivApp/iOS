//
//  FoodService.swift
//  UnivApp
//
//  Created by 정성윤 on 10/8/24.
//

import Foundation
import Combine

protocol FoodServiceType {
    func getSchoolRestaurants(universityId: Int) -> AnyPublisher<[FoodModel], Error>
    func getTopRestaurants() -> AnyPublisher<[FoodModel], Error>
}

class FoodService: FoodServiceType {
    private var subscriptions = Set<AnyCancellable>()
    
    func getSchoolRestaurants(universityId: Int) -> AnyPublisher<[FoodModel], any Error> {
        Future<[FoodModel], Error> { promise in
            Alamofire().getAlamofire(url: "\(APIEndpoint.schoolFood.urlString)\(universityId)")
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("학교 주변 맛집 조회 성공")
                    case let .failure(error):
                        print("학교 주변 맛집 조회 실패 \(error)")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (schoolFoodData: [FoodModel]) in
                    guard self != nil else { return }
                    promise(.success(schoolFoodData))
                }.store(in: &self.subscriptions)

        }.eraseToAnyPublisher()
    }
    
    func getTopRestaurants() -> AnyPublisher<[FoodModel], any Error> {
        Future<[FoodModel], Error> { promise in
            Alamofire().getAlamofire(url: APIEndpoint.topFood.urlString)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("탑 맛집 조회 성공")
                    case let .failure(error):
                        print("탑 맛집 조회 실패 \(error)")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (topFoodData: [FoodModel]) in
                    guard self != nil else { return }
                    promise(.success(topFoodData))
                }.store(in: &self.subscriptions)

        }.eraseToAnyPublisher()
    }
}

class StubFoodService: FoodServiceType {
    
    func getSchoolRestaurants(universityId: Int) -> AnyPublisher<[FoodModel], any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func getTopRestaurants() -> AnyPublisher<[FoodModel], any Error> {
        Empty().eraseToAnyPublisher()
    }
}
