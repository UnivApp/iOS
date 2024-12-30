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
    func checkAuthState() -> AnyPublisher<AuthStateModel, ServicesError>
    func signInAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String
    func signInAppleCompletion(_ auth: ASAuthorization, none: String) -> AnyPublisher<UserModel, ServicesError>
    func logout() -> AnyPublisher<Void, ServicesError>
    func withdrawMember() -> AnyPublisher<Void, ServicesError>
    
    func nonMemberLogin() -> AnyPublisher<UserModel, ServicesError>
}

final class AuthService: AuthServiceType {
    
    private var subscriptions = Set<AnyCancellable>()
    
    func checkAuthState() -> AnyPublisher<AuthStateModel, ServicesError> {
        Future<AuthStateModel, ServicesError> { promise in
            Alamofire().postAlamofire(url: APIEndpoint.status.urlString, params: nil)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("로그인 상태 체크 성공")
                    case let .failure(error):
                        print("로그인 상태 체크 실패")
                        promise(.failure(ServicesError.error(error)))
                    }
                } receiveValue: { [weak self] (result: AuthStateModel) in
                    guard self != nil else { return }
                    promise(.success((result)))
                }.store(in: &self.subscriptions)
        }.eraseToAnyPublisher()
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
        Future<Void, ServicesError> { promise in
            Alamofire().nonOfZeroPost(url: APIEndpoint.logout.urlString, params: nil)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("로그아웃 성공")
                    case let .failure(error):
                        print("로그아웃 실패")
                        promise(.failure(ServicesError.error(error)))
                    }
                } receiveValue: { [weak self] _ in
                    guard self != nil else { return }
                    promise(.success(()))
                }.store(in: &self.subscriptions)

        }.eraseToAnyPublisher()
    }
    
    func withdrawMember() -> AnyPublisher<Void, ServicesError> {
        Future<Void, ServicesError> { promise in
            Alamofire().delete(url: APIEndpoint.withdraw.urlString)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("회원탈퇴 성공")
                    case let .failure(error):
                        print("회원탈퇴 실패")
                        promise(.failure(ServicesError.error(error)))
                    }
                } receiveValue: { [weak self] _ in
                    guard self != nil else { return }
                    promise(.success(()))
                }.store(in: &self.subscriptions)
            
        }.eraseToAnyPublisher()
    }
    
    func nonMemberLogin() -> AnyPublisher<UserModel, ServicesError> {
        Future<UserModel, ServicesError> { promise in
            let params: [String:Any] = [
                "socialId": "nonMember",
                "name": "nonMember",
                "email": "nonMember"
            ]
            Alamofire().postAlamofire(url: APIEndpoint.login.urlString, params: params)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("비회원 로그인 성공")
                    case let .failure(error):
                        print("비회원 로그인 실패")
                        promise(.failure(ServicesError.error(error)))
                    }
                } receiveValue: { [weak self] (user: UserModel) in
                    guard self != nil else { return }
                    promise(.success(user))
                }.store(in: &self.subscriptions)

        }
        .eraseToAnyPublisher()
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
                    print("로그인 성공")
                case let .failure(error):
                    print("로그인 실패 \(error)")
                }
            } receiveValue: { [weak self] (user: UserModel) in
                guard self != nil else { return }
                completion(.success(user))
            }.store(in: &subscriptions)
    }
}

class StubAuthService: AuthServiceType {
    
    func nonMemberLogin() -> AnyPublisher<UserModel, ServicesError> {
        Empty().eraseToAnyPublisher()
    }
    
    func checkAuthState() -> AnyPublisher<AuthStateModel, ServicesError> {
        Empty().eraseToAnyPublisher()
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
    
    func withdrawMember() -> AnyPublisher<Void, ServicesError> {
        Empty().eraseToAnyPublisher()
    }
}
