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

class DiagnosisViewModel: ObservableObject {
    
    enum Action {
        
    }
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var question: [DiagnosisModel] = [
        DiagnosisModel(category: "학문적 관심", question: [
            "1. 논리적인 사고와 분석을 즐기는 편인가요?",
            "2. 새로운 아이디어를 탐구하고 창의적인 문제 해결을 좋아하나요?",
            "3. 실험이나 관찰을 통해 결과를 도출하는 활동에 흥미가 있나요?",
            "4. 인문학적 지식에 관심이 많고 역사나 철학에 대해 공부하는 것을 좋아하나요?",
            "5. 이론보다는 실제 현장 경험을 더 중시하나요?"]
                      ),
        DiagnosisModel(category: "직업적 목표", question: [
            "1. 사람들이 행복하게 생활할 수 있도록 도와주는 직업에 흥미가 있나요?",
            "2. 기술적이고 실용적인 기술을 배우는 것을 선호하나요?",
            "3. 팀 내에서 리더십을 발휘하는 것을 좋아하나요?",
            "4. 연구 개발보다는 사람들과 소통하며 일하는 직업에 관심이 있나요?",
            "5. 전통적인 직업보다 새로운 형태의 직업에 더 흥미를 느끼나요?"
        ]),
        DiagnosisModel(category: "학습 스타일", question: [
            "1. 독립적으로 공부하는 것을 좋아하나요?",
            "2. 토론식 수업을 좋아하고, 다양한 사람들과 의견을 교환하는 것을 즐기나요?",
            "3. 세부적인 계획보다는 큰 그림을 그리는 스타일인가요?",
            "4. 시간 관리와 규칙적인 계획을 잘 지키는 편인가요?",
            "5. 장시간 집중하는 것을 어려워하지 않나요?"
        ])
    ]
    @Published var selectedAnswer: Array<Int> = Array(repeating: 0, count: 5)
    @Published var totalAnswer: [Int] = []
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        
    }
    
    func calculateTotalScore(totalArray: [Int]) -> Int {
        return totalArray.reduce(0, +)
    }
    
    func initArray() {
        self.selectedAnswer = Array(repeating: 0, count: 5)
    }
}

