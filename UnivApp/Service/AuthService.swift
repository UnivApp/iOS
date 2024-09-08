//
//  AuthService.swift
//  UnivApp
//
//  Created by 정성윤 on 8/23/24.
//

import Foundation
import Combine
import AuthenticationServices

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
    
    func checkAuthState() -> String? {
        //TODO: 사용자 로그인 체크
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
        Empty().eraseToAnyPublisher()
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

extension AuthService {
    private func handleSignInAppleCompletion(_ auth: ASAuthorization, none: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        guard let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential,
              let appleIDToken = appleIDCredential.identityToken else {
            completion(.failure(AuthError.tokenError))
            return
        }
        
        //TODO: - JWT 서버 연결
        
    }
}
