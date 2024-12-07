//
//  DiagnosisService.swift
//  UnivApp
//
//  Created by 정성윤 on 10/21/24.
//

import Foundation
import Combine

protocol DiagnosisServiceType {
    func getQuestion() -> AnyPublisher<[DiagnosisModel], Error>
    func getResult(score: Int) -> AnyPublisher<DiagnosisResultModel, Error>
}

final class DiagnosisService: DiagnosisServiceType {
    private var subscriptions = Set<AnyCancellable>()
    
    func getQuestion() -> AnyPublisher<[DiagnosisModel], any Error> {
        Future<[DiagnosisModel], Error> { promise in
            Alamofire().getAlamofire(url: "\(APIEndpoint.diagnosisQuestion.urlString)")
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("진단 질문 조회 성공")
                    case let .failure(error):
                        print("진단 질문 조회 실패 \(error)")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (questionData: [DiagnosisModel]) in
                    guard self != nil else { return }
                    promise(.success(questionData))
                }.store(in: &self.subscriptions)
        }.eraseToAnyPublisher()
    }
    
    func getResult(score: Int) -> AnyPublisher<DiagnosisResultModel, any Error> {
        Future<DiagnosisResultModel, Error> { promise in
            Alamofire().getAlamofire(url: "\(APIEndpoint.diagnosisResult.urlString)\(score)")
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("진단 결과 조회 성공")
                    case let .failure(error):
                        print("진단 결과 조회 실패 \(error)")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (resultData: DiagnosisResultModel) in
                    guard self != nil else { return }
                    promise(.success(resultData))
                }.store(in: &self.subscriptions)

        }.eraseToAnyPublisher()
    }
    
}

final class StubDiagnosisService: DiagnosisServiceType {
    
    func getQuestion() -> AnyPublisher<[DiagnosisModel], any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func getResult(score: Int) -> AnyPublisher<DiagnosisResultModel, any Error> {
        Empty().eraseToAnyPublisher()
    }
}
