//
//  ListDetailModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/10/24.
//

import Foundation

struct ListDetailModel: Hashable, Codable {
    var universityId : Int?
    var fullName: String?
    var location: String?
    var type: String?
    var logo: String?
    var phoneNumber: String?
    var website: String?
    var admissionSite: String?
    var starNum: Int?
    var tuitionFeeResponse: [TuitionFeeResponse]?
    var departmentResponses: [DepartmentResponses?]?
    var competitionRateResponses: [CompetitionRateResponses?]?
    var employmentRateResponses: [EmploymentRateResponses?]?
}

struct TuitionFeeResponse: Codable, Hashable {
    var year: String?
    var tuitionFeeResponseList: [TuitionFeeResponseList]?
    
    struct TuitionFeeResponseList: Codable, Hashable {
        var departmentType: String
        var feeAmount: Double
    }
}

struct DepartmentResponses: Hashable, Codable {
    var name: [String]?
    var type: String?
}

struct CompetitionRateResponses: Hashable, Codable {
    var earlyAdmissionRate: Double?
    var regularAdmissionRate: Double?
    var year: String?
    var averageAdmissionRate: Double?
}

struct EmploymentRateResponses: Hashable, Codable {
    var employmentRate: Double?
    var year: String?
}
