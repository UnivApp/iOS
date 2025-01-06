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
enum RefreshTokenState {
    case unExpired
    case Expired
}

final class AuthViewModel: ObservableObject {
    
    enum Action {
        case checkAuthState
        case appleLogin(ASAuthorizationAppleIDRequest)
        case appleLoginCompletion(Result<ASAuthorization, Error>)
        case nonMemberLogin
        case logout
        case withdraw
    }
    
    @Published var authState: AuthState
    @Published var refreshTokenState: RefreshTokenState = .unExpired
    @Published var phase: Phase = .notRequested
    @Published var isNicknamePopup: Bool = false
    
    var userId: String?
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    private var currentNonce : String?
    
    init(container: DIContainer, authState: AuthState) {
        self.container = container
        self.authState = authState
    }
    
    func send(action: Action) {
        switch action {
        case .checkAuthState:
            container.services.authService.checkAuthState()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.authState = .unAuth
                        if UserDefaults.standard.string(forKey: "FirstUser") == "true" {
                            self?.refreshTokenState = .unExpired
                        } else {
                            self?.refreshTokenState = .Expired
                        }
                    }
                } receiveValue: { [weak self] checkStatus in
                    if checkStatus.loggedIn {
                        self?.authState = .auth
                        if let memberState = (UserDefaults.standard.value(forKey: "nonMember")) {
                            if (checkStatus.nicknameSet == false) && (memberState as! String == "false") {
                                self?.isNicknamePopup = true
                            }
                        }
                    } else {
                        self?.authState = .unAuth
                        if UserDefaults.standard.string(forKey: "FirstUser") == "true" {
                            self?.refreshTokenState = .unExpired
                        } else {
                            self?.refreshTokenState = .Expired
                        }
                    }
                }.store(in: &subscriptions)
            
        case let .appleLogin(request):
            let nonce = container.services.authService.signInAppleRequest(request)
            self.currentNonce = nonce
            
        case let .appleLoginCompletion(result):
            if case let .success(authorization) = result {
                guard let nonce = currentNonce else { return }
                container.services.authService.signInAppleCompletion(authorization, none: nonce)
                    .sink { [weak self] completion in
                        if case .failure = completion {
                            self?.phase = .fail
                            self?.authState = .unAuth
                        }
                    } receiveValue: { [weak self] user in
                        self?.userId = user.accessToken
                        self?.authState = .auth
                        UserDefaults.standard.removeObject(forKey: "nonMember")
                        UserDefaults.standard.setValue("false", forKey: "nonMember")
                        if let accessToken = user.accessToken,
                           let refreshToken = user.refreshToken {
                            KeychainWrapper.standard.removeAllKeys()
                            KeychainWrapper.standard.set("Bearer \(accessToken)", forKey: "JWTaccessToken")
                            KeychainWrapper.standard.set(refreshToken, forKey: "JWTrefreshToken")
                            self?.send(action: .checkAuthState)
                        }
                    }.store(in: &subscriptions)
            } else if case let .failure(error) = result {
                print(error.localizedDescription)
            }
            
        case .nonMemberLogin:
            self.phase = .loading
            container.services.authService.nonMemberLogin()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                        self?.authState = .unAuth
                    }
                } receiveValue: { [weak self] user in
                    self?.userId = user.accessToken
                    self?.authState = .auth
                    UserDefaults.standard.removeObject(forKey: "nonMember")
                    UserDefaults.standard.setValue("true", forKey: "nonMember")
                    if let accessToken = user.accessToken,
                       let refreshToken = user.refreshToken {
                        KeychainWrapper.standard.removeAllKeys()
                        KeychainWrapper.standard.set("Bearer \(accessToken)", forKey: "JWTaccessToken")
                        KeychainWrapper.standard.set(refreshToken, forKey: "JWTrefreshToken")
                        self?.send(action: .checkAuthState)
                    }
                }.store(in: &subscriptions)
            
        case .logout:
            self.phase = .loading
            container.services.authService.logout()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] _ in
                    KeychainWrapper.standard.removeAllKeys()
                    self?.phase = .success
                }.store(in: &subscriptions)
            
            
        case .withdraw:
            self.phase = .loading
            container.services.authService.withdrawMember()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] _ in
                    KeychainWrapper.standard.removeAllKeys()
                    self?.phase = .success
                }.store(in: &subscriptions)

        }
    }
}
