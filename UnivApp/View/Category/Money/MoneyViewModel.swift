//
//  MoneyViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//
import Foundation
import Combine
import Charts

class MoneyViewModel: ObservableObject {
    
    enum Action {
        case load(String, String)
    }
    
    @Published var phase: Phase = .notRequested
    @Published var rentData: [MoneyModel] = []
    @Published var averageRent: [String] = ["","",""]
    @Published var selectedType: MoneySelectedType = .officeTel
    @Published var address: String = ""
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case let .load(CGG_NM, BLDG_USG):
            self.phase = .loading
            container.services.moneyService.getRent(CGG_NM: CGG_NM, BLDG_USG: BLDG_USG)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] response in
                    if  let response = response.tbLnOpendataRentV?.row,
                        let average = self?.calculateAverage(data: response) {
                        self?.rentData = response.filter { rent in
                            rent.RENT_SE == "월세"
                        }
                        self?.averageRent = average
                    }
                    self?.phase = .success
                }
                .store(in: &subscriptions)

        }
    }
    
    func calculateAverage(data: [MoneyModel]) -> [String] {
        let totalGRFE = data.compactMap { Int($0.GRFE) }.reduce(0, +)
        let totalRTFE = data.compactMap { Int($0.RTFE) }.reduce(0, +)
        let totalAREA = data.compactMap { Int($0.RENT_AREA) }.reduce(0, +)
        
        let count = data.count
        
        let averageGRFE = count > 0 ? totalGRFE / count : 0
        let averageRTFE = count > 0 ? totalRTFE / count : 0
        let averageAREA = count > 0 ? totalAREA / count : 0
        
        return ["\(averageGRFE)", "\(averageRTFE)", "\(averageAREA)"]
    }

}

