//
//  AuthService.swift
//  UnivApp
//
//  Created by 정성윤 on 8/23/24.
//

import Foundation
import Combine
import AuthenticationServices
import Alamofire

enum AuthError: Error {
    case clientIDError
    case tokenError
    case invalidated
}

protocol AuthServiceType {
    func checkAuthState() -> String?
    func signInAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String
    func signInAppleCompletion(_ auth: ASAuthorization, none: String) -> AnyPublisher<UserModel, ServicesError>
    func logout() -> AnyPublisher<Void, ServicesError>
}

class AuthService: AuthServiceType {
    
    private var subscriptions = Set<AnyCancellable>()
    
    func checkAuthState() -> String? {
        //TODO: 사용자 로그인 체크 -> 메서드 필요
        return nil
    }
    
    func signInAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        return nonce
    }
    
    func signInAppleCompletion(_ auth: ASAuthorization, none: String) -> AnyPublisher<UserModel, ServicesError> {
        Future { [weak self] promise in
            self?.handleSignInAppleCompletion(auth, none: none) { result in
                switch result {
                case let .success(user):
                    promise(.success(user))
                case let .failure(error):
                    promise(.failure(.error(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, ServicesError> {
        //TODO: 로그아웃 메서드
        Empty().eraseToAnyPublisher()
    }
    
}

extension AuthService {
    private func handleSignInAppleCompletion(_ auth: ASAuthorization, none: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        guard let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential else {
            completion(.failure(AuthError.tokenError))
            return
        }
        let userIdentifier = appleIDCredential.user
        let name = appleIDCredential.fullName?.givenName ?? "익명"
        let email = appleIDCredential.email ?? "Permission@Denied"
        
        let params : [String:Any] = [
            "socialId" : userIdentifier,
            "name" : name,
            "email" : email
        ]
        
        Alamofire().loginAlamofire(url: APIEndpoint.login.urlString, params: params)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Request finished")
                case let .failure(error):
                    print("Request failed \(error)")
                }
            } receiveValue: { [weak self] (user: UserModel) in
                guard let self = self else { return }
                completion(.success(user))
            }.store(in: &subscriptions)
    }
}

class StubAuthService: AuthServiceType {
    
    func checkAuthState() -> String? {
        return nil
    }
    
    func signInAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String {
        return ""
    }
    
    func signInAppleCompletion(_ auth: ASAuthorization, none: String) -> AnyPublisher<UserModel, ServicesError> {
        Empty().eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, ServicesError> {
        Empty().eraseToAnyPublisher()
    }
    
}
