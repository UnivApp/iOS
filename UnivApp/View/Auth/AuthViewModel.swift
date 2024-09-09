//
//  AuthViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 8/22/24.
//

import Foundation
import Combine
import AuthenticationServices

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
    }
    
    @Published var authState: AuthState = .unAuth
    @Published var isLoading: Bool = false
    
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
            //TODO: 로그인 상태 확인 메서드
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
                    }.store(in: &subscriptions)
            } else if case let .failure(error) = result {
                print(error.localizedDescription)
            }
            
        case .logout:
            return
        }
    }
}
