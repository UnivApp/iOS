//
//  Alamofire.swift
//  UnivApp
//
//  Created by 정성윤 on 9/9/24.
//

import Foundation
import Alamofire
import Combine

final class Alamofire {
    func loginAlamofire<T:Decodable>(url: String, params: [String:Any]) -> AnyPublisher<T, Error> {
        return Future<T, Error> { promise in
            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"])
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case let .success(result):
                        promise(.success(result))
                    case let .failure(error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    func postAlamofire<T:Decodable>(url: String, params: [String:Any]) -> AnyPublisher<T, Error> {
        return Future<T, Error> { promise in
            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["content-Type":"application-json"])
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case let .success(result):
                        promise(.success(result))
                    case let .failure(error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    func getAlamofire<T:Decodable>(url: String) -> AnyPublisher<T, Error> {
        return Future<T, Error> { promise in
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["content-Type":"application-json"])
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case let .success(result):
                        promise(.success(result))
                    case let .failure(error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
