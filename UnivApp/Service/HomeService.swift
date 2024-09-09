//
//  HomeService.swift
//  UnivApp
//
//  Created by 정성윤 on 9/9/24.
//

import Foundation
import Combine

protocol HomeServiceType {
    func getBanners() -> AnyPublisher<[BannerModel], Error>
    func getScoreImage() -> AnyPublisher<ScoreImageModel, Error>
}

class HomeService: HomeServiceType {
    private var subscriptions = Set<AnyCancellable>()
    
    func getBanners() -> AnyPublisher<[BannerModel], any Error> {
        Future<[BannerModel], Error> { promise in
            Alamofire().getAlamofire(url: APIEndpoint.banners.urlString)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Request finished")
                    case let .failure(error):
                        print("Request failed \(error)")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (banners: [BannerModel]) in
                    guard self != nil else { return }
                    promise(.success(banners))
                }.store(in: &self.subscriptions)
        }.eraseToAnyPublisher()
    }
    
    func getScoreImage() -> AnyPublisher<ScoreImageModel, any Error> {
        Future<ScoreImageModel, Error> { promise in
            Alamofire().getAlamofire(url: APIEndpoint.scoreImage.urlString)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Request finished")
                    case let .failure(error):
                        print("Request failed \(error)")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (image: ScoreImageModel) in
                    guard self != nil else { return }
                    promise(.success(image))
                }.store(in: &self.subscriptions)

        }.eraseToAnyPublisher()
    }
}

class StubHomeService: HomeServiceType {
    func getBanners() -> AnyPublisher<[BannerModel], any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func getScoreImage() -> AnyPublisher<ScoreImageModel, any Error> {
        Empty().eraseToAnyPublisher()
    }
}
