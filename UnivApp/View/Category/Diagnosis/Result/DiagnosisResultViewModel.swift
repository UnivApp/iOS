//
//  DiagnosisResultViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 10/21/24.
//

import Foundation
import Combine

enum DiagnosisImageType: String {
    case Practical
    case Balanced
    case Analytical
    case Creative
    case Professional
    
    var image: String {
        switch self {
        case .Practical:
            return "PracticalType"
        case .Balanced:
            return "BalancedType"
        case .Analytical:
            return "AnalyticalType"
        case .Creative:
            return "CreativeType"
        case .Professional:
            return "ResearchType"
        }
    }
    
    init?(matchingResultType: String) {
        switch matchingResultType {
        case _ where matchingResultType.contains("혁신형"):
            self = .Creative
        case _ where matchingResultType.contains("분석형"):
            self = .Analytical
        case _ where matchingResultType.contains("실천형"):
            self = .Practical
        case _ where matchingResultType.contains("균형형"):
            self = .Balanced
        case _ where matchingResultType.contains("연구형"):
            self = .Professional
        default:
            return nil
        }
    }
}

class DiagnosisResultViewModel: ObservableObject {
    
    enum Action {
        case resultLoad(Int)
    }
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var phase: Phase = .notRequested
    @Published var result: DiagnosisResultModel = .init()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .resultLoad(let score):
            self.phase = .loading
            container.services.diagnosisService.getResult(score: score)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] resultData in
                    self?.result = resultData
                    self?.phase = .success
                }.store(in: &subscriptions)
        }
    }
    
    func calculateTotalScore(totalArray: [Int]) -> Int {
        return totalArray.reduce(0, +)
    }

}


