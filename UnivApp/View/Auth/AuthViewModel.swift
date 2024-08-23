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
    
    @Published var authState: AuthState = .auth
    @Published var isLoading: Bool = false
    
    private var container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case let .appleLogin(request):
            return
        case let .appleLoginCompletion(completion):
            return
        case .checkAuthState:
            return
        case .logout:
            return
        }
    }
}
