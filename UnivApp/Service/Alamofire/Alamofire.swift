//
//  Alamofire.swift
//  UnivApp
//
//  Created by 정성윤 on 9/9/24.
//

import Foundation
import Alamofire
import Combine
import SwiftKeychainWrapper

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
    
    func nonOfZeroPost(url: String, params: [String:Any]?) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            if let accessToken = KeychainWrapper.standard.string(forKey: "JWTaccessToken") {
                if let params = params {
                    AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["content-Type":"application/json", "Authorization": accessToken])
                        .validate()
                        .response { response in
                            switch response.result {
                            case .success:
                                if response.data?.isEmpty ?? true {
                                    promise(.success(()))
                                } else {
                                    promise(.success(()))
                                }
                            case let .failure(error):
                                promise(.failure(error))
                            }
                        }
                } else {
                    AF.request(url, method: .post, encoding: JSONEncoding.default, headers: ["content-Type":"application/json", "Authorization": accessToken])
                        .validate()
                        .response { response in
//                            print(response.debugDescription)
                            switch response.result {
                            case .success:
                                if response.data?.isEmpty ?? true {
                                    promise(.success(()))
                                } else {
                                    promise(.success(()))
                                }
                            case let .failure(error):
                                promise(.failure(error))
                            }
                        }
                }
            } else {
                promise(.failure(NSError(domain: "Token Error", code: 401, userInfo: nil)))
            }
        }.eraseToAnyPublisher()
    }
    
    func delete(url: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            if let accessToken = KeychainWrapper.standard.string(forKey: "JWTaccessToken"){
                AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: ["content-Type":"application/json", "Authorization": accessToken])
                    .validate()
                    .response { response in
//                        print(response.debugDescription)
                        switch response.result {
                        case .success:
                            if response.data?.isEmpty ?? true {
                                promise(.success(()))
                            } else {
                                promise(.success(()))
                            }
                        case let .failure(error):
                            promise(.failure(error))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    func postAlamofire<T:Decodable>(url: String, params: [String:Any]?) -> AnyPublisher<T, Error> {
        return Future<T, Error> { promise in
            if let accessToken = KeychainWrapper.standard.string(forKey: "JWTaccessToken"){
                if let params = params {
                    AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["content-Type":"application-json", "Authorization":accessToken])
                        .validate()
                        .responseDecodable(of: T.self) { response in
                            switch response.result {
                            case let .success(result):
                                promise(.success(result))
                            case let .failure(error):
                                promise(.failure(error))
                            }
                        }
                } else {
                    AF.request(url, method: .post, encoding: JSONEncoding.default, headers: ["content-Type":"application-json", "Authorization":accessToken])
                        .validate()
                        .responseDecodable(of: T.self) { response in
//                            print(response.debugDescription)
                            switch response.result {
                            case let .success(result):
                                promise(.success(result))
                            case let .failure(error):
                                promise(.failure(error))
                            }
                        }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    func getAlamofire<T:Decodable>(url: String) -> AnyPublisher<T, Error> {
        return Future<T, Error> { promise in
            if let accessToken = KeychainWrapper.standard.string(forKey: "JWTaccessToken"){
                AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["content-Type":"application-json", "Authorization":accessToken])
                    .validate()
                    .responseDecodable(of: T.self) { response in
//                        print(response.debugDescription)
                        switch response.result {
                        case let .success(result):
                            promise(.success(result))
                        case let .failure(error):
                            promise(.failure(error))
                        }
                    }
            }
        }
        .eraseToAnyPublisher()
    }
}
