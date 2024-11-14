//
//  PlayViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import Foundation
import Combine

class PlayViewModel: ObservableObject {
    
    enum Action {
        case topPlaceLoad
        case schoolPlaceLoad(Int)
    }
    
    @Published var phase: Phase = .notRequested
    @Published var topPlaceData: [PlayModel] = []
    @Published var schoolPlaceData: [PlayModel] = []
    @Published var isNavigatingToDetail: Bool = false

    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .topPlaceLoad:
            self.phase = .loading
            container.services.playService.getTopPlace()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] topPlaceData in
                    self?.topPlaceData = topPlaceData
                    self?.phase = .success
                }.store(in: &subscriptions)
            
        case let .schoolPlaceLoad(universityId):
            self.phase = .loading
            container.services.playService.getSchoolPlace(universityId: universityId)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] schoolPlaceData in
                    self?.schoolPlaceData = schoolPlaceData
                    self?.phase = .success
                }.store(in: &subscriptions)
        }
    }
    
    func convertToObjects(from playModels: [PlayModel]) -> [Object] {
        return playModels.map { playModel in
            if let images = playModel.images,
               let firstImage = images.compactMap({ $0?.imageUrl }).first {
                return Object(title: playModel.name, image: firstImage)
            }
            return Object(title: "", image: "")
        }
    }
}
