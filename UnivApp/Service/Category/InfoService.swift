//
//  InfoService.swift
//  UnivApp
//
//  Created by 정성윤 on 10/8/24.
//

import Foundation
import Combine

protocol InfoServiceType {
    func getNewsList() -> AnyPublisher<[NewsModel], Error>
}

class InfoService: InfoServiceType {
    private var subscriptions = Set<AnyCancellable>()
    
    func getNewsList() -> AnyPublisher<[NewsModel], any Error> {
        Future<[NewsModel], Error> { promise in
            Alamofire().getAlamofire(url: APIEndpoint.news.urlString)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("뉴스 전체 조회 성공")
                    case let .failure(error):
                        print("뉴스 전체 조회 실패 \(error)")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (newsData: [NewsModel]) in
                    guard self != nil else { return }
                    promise(.success(newsData))
                }.store(in: &self.subscriptions)

        }.eraseToAnyPublisher()
    }
}

class StubInfoService: InfoServiceType {
    func getNewsList() -> AnyPublisher<[NewsModel], any Error> {
        Empty().eraseToAnyPublisher()
    }
}
