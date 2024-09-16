//
//  SearchService.swift
//  UnivApp
//
//  Created by 정성윤 on 9/9/24.
//

import Foundation
import Combine

protocol SearchServiceType {
    func getSearch(searchText: String) -> AnyPublisher<[SummaryModel], Error>
}

class SearchService: SearchServiceType {
    private var subscriptions = Set<AnyCancellable>()
    
    func getSearch(searchText: String) -> AnyPublisher<[SummaryModel], any Error> {
        Future<[SummaryModel], Error> { promise in
            Alamofire().getAlamofire(url: "\(APIEndpoint.search.urlString)\(searchText)")
                .sink {  completion in
                    switch completion {
                    case .finished:
                        print("Request finished")
                    case let .failure(error):
                        print("Request failed \(error)")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (search: [SummaryModel]) in
                    guard self != nil else { return }
                    promise(.success(search))
                }.store(in: &self.subscriptions)
            
        }.eraseToAnyPublisher()
    }
}

class StubSearchService: SearchServiceType {
    func getSearch(searchText: String) -> AnyPublisher<[SummaryModel], any Error> {
        Empty().eraseToAnyPublisher()
    }
}
