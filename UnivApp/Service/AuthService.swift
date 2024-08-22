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
    func signInAppleCompletion(_ auth: ASAuthorization, none: String) -> AnyPublisher<User, ServicesError>
    func logout() -> AnyPublisher<Void, ServicesError>
}

class AuthService: AuthServiceType {
    
    func checkAuthState() -> String? {
        return nil
    }
    
    func signInAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String {
        return ""
    }
    
    func signInAppleCompletion(_ auth: ASAuthorization, none: String) -> AnyPublisher<User, ServicesError> {
        Empty().eraseToAnyPublisher()
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
    
    func signInAppleCompletion(_ auth: ASAuthorization, none: String) -> AnyPublisher<User, ServicesError> {
        Empty().eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, ServicesError> {
        Empty().eraseToAnyPublisher()
    }
    
}
