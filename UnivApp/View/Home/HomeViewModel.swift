//
//  HomeViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    enum Action {
        case load
    }
    
    @Published var searchText: String
    @Published var phase: Phase = .notRequested
    @Published var banners: [BannerModel] = []
    @Published var scoreImage: ScoreImageModel = .init(type: nil, image: nil)
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer, searchText: String) {
        self.container = container
        self.searchText = searchText
    }
    
    func send(action: Action) {
        switch action {
        case .load:
            phase = .loading
            container.services.homeService.getBanners()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] banners in
                    self?.phase = .success
                    self?.banners = banners
                }.store(in: &subscriptions)

            container.services.homeService.getScoreImage()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] image in
                    self?.phase = .success
                    self?.scoreImage = image
                }.store(in: &subscriptions)
            
        }
    }
    
}
