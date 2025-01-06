//
//  SettingViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/10/24.
//

import Foundation
import Combine

final class SettingViewModel: ObservableObject {
    
    enum Action {
        case getLoad
        case createLoad
        case changeLoad
        case checkLoad
    }
    
    @Published var phase: Phase = .notRequested
    @Published var nickNamePhase: Phase = .notRequested
    @Published var duplicatePhase: Bool? = nil
    @Published var nickNameText: String = ""
    @Published var userNickname: String = ""
    
    private let container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .getLoad:
            self.phase = .loading
            container.services.settingService.getNickname()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] result in
                    self?.userNickname = result.nickName
                    self?.phase = .success
                }.store(in: &subscriptions)
            
        case .createLoad:
            self.nickNamePhase = .loading
            container.services.settingService.createNickname(nickName: self.nickNameText)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.nickNamePhase = .fail
                    }
                } receiveValue: { [weak self] result in
                    self?.nickNamePhase = .success
                }.store(in: &subscriptions)
            
        case .changeLoad:
            self.phase = .loading
            container.services.settingService.changeNickname(nickName: self.nickNameText)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.nickNamePhase = .fail
                    }
                } receiveValue: { [weak self] result in
                    self?.nickNamePhase = .success
                }.store(in: &subscriptions)
            
        case .checkLoad:
            container.services.settingService.checkNickname(nickName: self.nickNameText)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.duplicatePhase = false
                    }
                } receiveValue: { [weak self] result in
                    if result.duplicate {
                        self?.duplicatePhase = false
                    } else {
                        self?.duplicatePhase = true
                    }
                }.store(in: &subscriptions)

        }
    }
    
}
