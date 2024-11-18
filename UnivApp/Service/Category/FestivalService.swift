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
    
    private func extractItems(from responseString: String) -> String {
        var imageUrl: String = ""
        let parser = XMLParser(data: Data(responseString.utf8))
        let delegate = ManiadbParserDelegate()
        parser.delegate = delegate
        parser.parse()
        
        if let firstImage = delegate.imageURLs.first {
            imageUrl = firstImage
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
    
}
