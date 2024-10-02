//
//  RequestInterceptor + Extension.swift
//  UnivApp
//
//  Created by 정성윤 on 9/20/24.
//

import Foundation
import Alamofire
import Combine
import SwiftKeychainWrapper
import SwiftUI

final class TokenRequestInterceptor: RequestInterceptor {
    @ObservedObject var authViewModel: AuthViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = AuthViewModel(container: DIContainer(services: Services()))
    }

    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        if let accessToken = KeychainWrapper.standard.string(forKey: "JWTaccessToken") {
            if urlRequest.headers["Authorization"] == nil {
                urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
            }
        } else {
            print("액세스 토큰 없음")
        }

        completion(.success(urlRequest))
    }

    public func retry(_ request: Request,
                      for session: Session,
                      dueTo error: Error,
                      completion: @escaping (RetryResult) -> Void) {
        let retryLimit = 2

        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401, response.statusCode == 400 else {
            return completion(.doNotRetryWithError(error))
        }
        guard request.retryCount < retryLimit else { return completion(.doNotRetryWithError(error)) }
        Task {
            guard let refreshToken = KeychainWrapper.standard.string(forKey: "JWTrefreshToken") else {
                return completion(.doNotRetryWithError(error))
            }
            Alamofire().reissueRefresh(url: APIEndpoint.refresh.urlString, refresh: refreshToken)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("토큰 재발행 성공")
                    case let .failure(error):
                        print("토큰 재발행 실패 \(error)")
                        DispatchQueue.main.async {
                            self.authViewModel.authState = .unAuth
                            self.authViewModel.refreshTokenState = .Expired
                        }
                    }
                } receiveValue: { (response: UserModel) in
                    KeychainWrapper.standard.removeAllKeys()
                    if let accessToken = response.accessToken,
                       let refreshToken = response.refreshToken {
                        print("토큰 재발행 성공")
                        KeychainWrapper.standard.set("Bearer \(accessToken)", forKey: "JWTaccessToken")
                        KeychainWrapper.standard.set(refreshToken, forKey: "JWTrefreshToken")
                    }
                    return completion(.retry)
                }.store(in: &subscriptions)
        }
    }
}
