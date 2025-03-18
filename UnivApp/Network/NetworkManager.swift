//
//  NetworkManager.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import Foundation
import Alamofire
import Combine

protocol NetworkManagerType: AnyObject {
    func fetchData<T: Decodable, U: Router>(_ api: U) -> AnyPublisher<T,Error>
}

final class NetworkManager: NetworkManagerType {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func fetchData<T: Decodable, U: Router>(_ api: U) -> AnyPublisher<T,Error> {
//        print(api.endpoint)
        return Future<T,Error> { promise in
            AF.request(api)
                .validate(statusCode: 200...500)
                .responseDecodable(of: T.self) { response in
//                    dump(response.debugDescription)
//                    let statucCode = NetworkError().checkErrorType(response.response?.statusCode)
                    switch response.result {
                    case let .success(data):
                        promise(.success(data))
                    case let .failure(error):
                        promise(.failure(error))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
}
