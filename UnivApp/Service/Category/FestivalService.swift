//
//  FestivalService.swift
//  UnivApp
//
//  Created by 정성윤 on 11/18/24.
//

import Foundation
import Combine
import Alamofire

protocol FestivalServiceType {
    func getArtist(name: String) -> AnyPublisher<String, Error>
    func topArtists() -> AnyPublisher<[TalentModel],Error>
    func getFestival(universityId: String) -> AnyPublisher<FestivalDetailModel,Error>
}

class FestivalService: FestivalServiceType {
    
    private var subscriptions = Set<AnyCancellable>()
    
    func getArtist(name: String) -> AnyPublisher<String, any Error> {
        Future<String, Error> { promise in
            AF.request("\(APIEndpoint.getArtist.urlString)\(name)/?sr=artist&display=1&key=example&v=0.5", method: .get)
                .validate()
                .response { response in
                    switch response.result {
                    case .success(let data):
                        if let responseString = String(data: data!, encoding: .utf8) {
                            let items = self.extractItems(from: responseString)
                            promise(.success(items))
                        }
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    func topArtists() -> AnyPublisher<[TalentModel], any Error> {
        Future<[TalentModel], Error> { promise in
            Alamofire().getAlamofire(url: APIEndpoint.topArtist.urlString)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("탑 연예인 조회 성공")
                    case let .failure(error):
                        print("탑 연예인 조회 실패")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (artists: [TalentModel]) in
                    guard self != nil else { return }
                    promise(.success(artists))
                }.store(in: &self.subscriptions)

        }.eraseToAnyPublisher()
    }
    
    func getFestival(universityId: String) -> AnyPublisher<FestivalDetailModel, any Error> {
        Future<FestivalDetailModel, Error> { promise in
            Alamofire().getAlamofire(url: "\(APIEndpoint.getFestival.urlString)\(universityId)")
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("축제 정보 조회 성공")
                    case let .failure(error):
                        print("축제 정보 조회 실패")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (festival: FestivalDetailModel) in
                    guard self != nil else { return }
                    promise(.success(festival))
                }.store(in: &self.subscriptions)

        }.eraseToAnyPublisher()
    }
    
    private func extractItems(from responseString: String) -> String {
        var imageUrl: String = ""
        let parser = XMLParser(data: Data(responseString.utf8))
        let delegate = ManiadbParserDelegate()
        parser.delegate = delegate
        parser.parse()
        
        if let firstImage = delegate.imageURLs.first {
            imageUrl = firstImage
        } else {
            return "http://i.maniadb.com"
        }
        return imageUrl
    }
}

class ManiadbParserDelegate: NSObject, XMLParserDelegate {
    var currentElement = ""
    var imageURLs: [String] = []
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElement == "image" {
            let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedString.isEmpty {
                imageURLs.append(trimmedString)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement = ""
    }
}

class StubFestivalService: FestivalServiceType {
    
    func getArtist(name: String) -> AnyPublisher<String, any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func topArtists() -> AnyPublisher<[TalentModel], any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func getFestival(universityId: String) -> AnyPublisher<FestivalDetailModel, any Error> {
        Empty().eraseToAnyPublisher()
    }
}
