//
//  ListService.swift
//  UnivApp
//
//  Created by 정성윤 on 9/9/24.
//

import Foundation
import Combine

protocol ListServiceType {
    func getSummary() -> AnyPublisher<[SummaryModel], Error>
}

class ListService: ListServiceType {
    private var subscriptions = Set<AnyCancellable>()
    
    func getSummary() -> AnyPublisher<[SummaryModel], any Error> {
        Future<[SummaryModel], Error> { promise in
            Alamofire().getAlamofire(url: APIEndpoint.summary.urlString)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Request finished")
                    case let .failure(error):
                        print("Request failed \(error)")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (summary: [SummaryModel]) in
                    guard self != nil else { return }
                    promise(.success(summary))
                }.store(in: &self.subscriptions)
        }
        .eraseToAnyPublisher()
    }
}

class StubListService: ListServiceType {
    func getSummary() -> AnyPublisher<[SummaryModel], any Error> {
        Empty().eraseToAnyPublisher()
    }
}
