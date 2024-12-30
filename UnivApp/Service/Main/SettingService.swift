//
//  SettingService.swift
//  UnivApp
//
//  Created by 정성윤 on 11/1/24.
//

import Foundation
import Combine

protocol SettingServiceType {
    func checkNickname(nickName: String) -> AnyPublisher<CheckNicknameModel, Error>
    func createNickname(nickName: String) -> AnyPublisher<NicknameModel, Error>
    func changeNickname(nickName: String) -> AnyPublisher<NicknameModel, Error>
    func getNickname() -> AnyPublisher<NicknameModel, Error>
}

final class SettingService: SettingServiceType {
    
    private var subscriptions = Set<AnyCancellable>()
    
    func checkNickname(nickName: String) -> AnyPublisher<CheckNicknameModel, any Error> {
        Future<CheckNicknameModel, Error> { promise in
            Alamofire().getAlamofire(url: "\(APIEndpoint.checkNickname.urlString)\(nickName)")
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("닉네임 중복 체크 성공")
                    case let .failure(error):
                        print("닉네임 중복 체크 실패")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (result: CheckNicknameModel) in
                    guard self != nil else { return }
                    promise(.success(result))
                }.store(in: &self.subscriptions)
        }.eraseToAnyPublisher()
    }
    
    func createNickname(nickName: String) -> AnyPublisher<NicknameModel, any Error> {
        Future<NicknameModel, Error> { promise in
            Alamofire().postAlamofire(url: "\(APIEndpoint.createNickname.urlString)\(nickName)", params: nil)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("닉네임 생성 성공")
                    case let .failure(error):
                        print("닉네임 생성 실패")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (result: NicknameModel) in
                    guard self != nil else { return }
                    promise(.success(result))
                }.store(in: &self.subscriptions)
        }.eraseToAnyPublisher()
    }
    
    func changeNickname(nickName: String) -> AnyPublisher<NicknameModel, any Error> {
        Future<NicknameModel, Error> { promise in
            let params: [String:Any] = [
                "nickName" : nickName
            ]
            Alamofire().putAlamofire(url: APIEndpoint.changeNickname.urlString, params: params)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("닉네임 변경 성공")
                    case let .failure(error):
                        print("닉네임 변경 실패")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (result: NicknameModel) in
                    guard self != nil else { return }
                    promise(.success(result))
                }.store(in: &self.subscriptions)
        }.eraseToAnyPublisher()
    }
    
    func getNickname() -> AnyPublisher<NicknameModel, any Error> {
        Future<NicknameModel, Error> { promise in
            Alamofire().getAlamofire(url: APIEndpoint.getNickname.urlString)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("닉네임 조회 성공")
                    case let .failure(error):
                        print("닉네임 조회 실패")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (result: NicknameModel) in
                    guard self != nil else { return }
                    promise(.success(result))
                }.store(in: &self.subscriptions)
        }.eraseToAnyPublisher()
    }
    
}

final class StubSettingService: SettingServiceType {
    
    func checkNickname(nickName: String) -> AnyPublisher<CheckNicknameModel, any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func createNickname(nickName: String) -> AnyPublisher<NicknameModel, any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func changeNickname(nickName: String) -> AnyPublisher<NicknameModel, any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func getNickname() -> AnyPublisher<NicknameModel, any Error> {
        Empty().eraseToAnyPublisher()
    }
}
