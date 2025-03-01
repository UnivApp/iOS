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

final class SearchService: SearchServiceType {
    private var subscriptions = Set<AnyCancellable>()
    
    func getSearch(searchText: String) -> AnyPublisher<[SummaryModel], any Error> {
        Future<[SummaryModel], Error> { promise in
            Alamofire().getAlamofire(url: "\(APIEndpoint.search.urlString)\(searchText)")
                .sink {  completion in
                    switch completion {
                    case .finished:
                        print("학교 검색 성공")
                    case let .failure(error):
                        print("학교 검색 실패 \(error)")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (search: [SummaryModel]) in
                    guard self != nil else { return }
                    promise(.success(search))
                }.store(in: &self.subscriptions)
            
        }.eraseToAnyPublisher()
    }
}

final class StubSearchService: SearchServiceType {
    func getSearch(searchText: String) -> AnyPublisher<[SummaryModel], any Error> {
        Empty().eraseToAnyPublisher()
    }
}
