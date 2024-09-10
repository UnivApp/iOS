//
//  AuthViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 8/22/24.
//

import Foundation
import Combine
import AuthenticationServices
import SwiftKeychainWrapper

enum AuthState {
    case unAuth
    case auth
}

class AuthViewModel: ObservableObject {
    
    enum Action {
        case checkAuthState
        case appleLogin(ASAuthorizationAppleIDRequest)
        case appleLoginCompletion(Result<ASAuthorization, Error>)
        case logout
        case withdraw
    }
    
    @Published var authState: AuthState = .auth
    @Published var isLoading: Bool = false
    @Published var phase: Phase = .notRequested
    
    var userId: String?
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    private var currentNonce : String?
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .checkAuthState:
            container.services.authService.checkAuthState()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        //TODO: - 상태 체크 실패
                    }
                } receiveValue: { [weak self] checkStatus in
                    //TODO: - 로그인 상태 체크 성공
                }.store(in: &subscriptions)

            return
            
        case let .appleLogin(request):
            let nonce = container.services.authService.signInAppleRequest(request)
            self.currentNonce = nonce
            
        case let .appleLoginCompletion(result):
            if case let .success(authorization) = result {
                guard let nonce = currentNonce else { return }
                isLoading = true
                container.services.authService.signInAppleCompletion(authorization, none: nonce)
                    .sink { completion in
                        if case .failure = result {
                            self.isLoading = false
                        }
                    } receiveValue: { [weak self] user in
                        self?.isLoading = false
                        self?.userId = user.accessToken
                        self?.authState = .auth
                        if let accessToken = user.accessToken {
                            KeychainWrapper.standard.remove(forKey: "JWTaccessToken")
                            KeychainWrapper.standard.set("Bearer \(accessToken)", forKey: "JWTaccessToken")
                        }
                    }.store(in: &subscriptions)
            } else if case let .failure(error) = result {
                print(error.localizedDescription)
            }
            
        case .logout:
            KeychainWrapper.standard.removeAllKeys()
            container.services.authService.logout()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        //TODO: - 로그아웃 실패
                    }
                } receiveValue: { [weak self] _ in
                    //TODO: - 로그아웃 성공
                }.store(in: &subscriptions)
            
            
            
        case .withdraw:
            KeychainWrapper.standard.removeAllKeys()
            container.services.authService.withdrawMember()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        //TODO: - 회원 탈퇴 실패
                    }
                } receiveValue: { [weak self] _ in
                    //TODO: - 회원 탈퇴 성공
                }.store(in: &subscriptions)

        }
    }
}
