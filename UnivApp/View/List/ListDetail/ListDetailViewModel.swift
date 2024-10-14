//
//  ListDetailViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/5/24.
//

import Foundation
import Combine
import SwiftUI

class ListDetailViewModel: ObservableObject {
    
    enum Action {
        case load(Int)
    }
    
    @Published var phase: Phase = .notRequested
    @Published var listDetail: ListDetailModel = ListDetailModel()
    @Published var tuitionFeeData: [ChartData] = []
    @Published var departmentData: [ChartData] = []
    @Published var competitionRateData: [[ChartData]] = []
    @Published var employmentRateData: [[ChartData]] = []
    
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case let .load(universityId):
            self.phase = .loading
            container.services.listService.getDetail(universityId: universityId)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] listDetail in
                    self?.listDetail = listDetail
                    self?.setChartData()
                }.store(in: &subscriptions)

        }
    }
    
    func setChartData() {
        if let tuitionResponses = listDetail.tuitionFeeResponse,
           let departmentResponses = listDetail.departmentResponses,
           let competitionRateResponses = listDetail.competitionRateResponses,
           let employmentRateResponses = listDetail.employmentRateResponses {
            
            if let year = tuitionResponses.year,
               let tuitionList = tuitionResponses.tuitionFeeResponseList {
                for tuition in tuitionList {
                    self.tuitionFeeData = []
                    self.tuitionFeeData.append(ChartData(label: tuition.departmentType, value: Double(Double(tuition.feeAmount) / Double(12)), xLabel: "", yLabel: "", year: year))
                }
            }
            
            for depart in departmentResponses {
                if let depart = depart,
                   let name = depart.name,
                   let type = depart.type {
                    var sum: Int = 0
                    for n in departmentResponses.compactMap({ $0?.name }) {
                        sum += n.count
                    }
                    self.departmentData = []
                    self.departmentData.append(ChartData(label: type, value: Double(Double(name.count) / Double(sum)), xLabel: "과", yLabel: "", year: ""))
                }
            }
            
            for competition in competitionRateResponses {
                if let competition = competition,
                   let earlyAdmissionRate = competition.earlyAdmissionRate,
                   let regularAdmissionRate = competition.regularAdmissionRate,
                   let year = competition.year {
                    self.competitionRateData = []
                    self.competitionRateData.append([ChartData(label: "수시", value: Double(earlyAdmissionRate), xLabel: "년도", yLabel: "비율", year: year), ChartData(label: "정시", value: Double(regularAdmissionRate), xLabel: "년도", yLabel: "비율", year: year)])
                }
            }
            
            for employment in employmentRateResponses {
                if let employment = employment,
                   let employmentRate = employment.employmentRate,
                   let year = employment.year {
                    self.employmentRateData = []
                    self.employmentRateData.append([ChartData(label: "취업률", value: Double(employmentRate), xLabel: "년도", yLabel: "비율", year: year)])
                }
            }
        }
        self.phase = .success
    }
}
