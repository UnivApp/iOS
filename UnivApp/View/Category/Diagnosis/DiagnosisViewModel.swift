//
//  GraduateViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import Foundation
import Combine

enum DiagnosisButton: String, CaseIterable {
    case notVery
    case not
    case commonly
    case ok
    case okVery
    
    var title: String {
        switch self {
        case .notVery:
            return "매우 아니다"
        case .not:
            return "아니다"
        case .commonly:
            return "보통"
        case .ok:
            return "그렇다"
        case .okVery:
            return "매우 그렇다"
        }
    }
    
    var point: Int {
        switch self {
        case .notVery:
            return 1
        case .not:
            return 2
        case .commonly:
            return 3
        case .ok:
            return 4
        case .okVery:
            return 5
        }
    }
}

final class DiagnosisViewModel: ObservableObject {
    
    enum Action {
        case questionLoad
    }
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var phase: Phase = .notRequested
    @Published var question: [DiagnosisModel] = []
    @Published var selectedAnswer: Array<Int> = Array(repeating: 0, count: 5)
    @Published var totalAnswer: [Int] = []
    @Published var result: DiagnosisResultModel = .init()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .questionLoad:
            self.phase = .loading
            container.services.diagnosisService.getQuestion()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] questionData in
                    self?.question = questionData
                    self?.phase = .success
                }.store(in: &subscriptions)
        }
    }
    
    func calculateTotalScore(totalArray: [Int]) -> Int {
        return totalArray.reduce(0, +)
    }
    
    func initArray() {
        self.selectedAnswer = Array(repeating: 0, count: 5)
    }
}

