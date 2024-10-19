//
//  MoneyModel.swift
//  UnivApp
//
//  Created by 정성윤 on 10/18/24.
//
import Foundation

struct RentModel: Codable {
    let tbLnOpendataRentV: RentData?
}

struct RentData: Codable {
    let list_total_count: Int
    let RESULT: RentResult
    let row: [MoneyModel]
}

struct RentResult: Codable {
    let CODE: String
    let MESSAGE: String
}

struct MoneyModel: Codable, Hashable {
    let RCPT_YR: String          // 접수연도
    let CGG_CD: String           // 자치구코드
    let CGG_NM: String           // 자치구명
    let STDG_CD: String          // 법정동코드
    let STDG_NM: String          // 법정동명
    let LOTNO_SE: String         // 지번구분
    let LOTNO_SE_NM: String      // 지번구분명
    let MNO: String              // 본번
    let SNO: String?             // 부번 (optional)
    let FLR: Double              // 층
    let CTRT_DAY: String         // 계약일
    let RENT_SE: String          // 전월세 구분
    let RENT_AREA: Double        // 임대면적(㎡)
    let GRFE: String             // 보증금(만원)
    let RTFE: String             // 임대료(만원)
    let BLDG_NM: String?         // 건물명 (optional)
    let ARCH_YR: String?         // 건축년도 (optional)
    let BLDG_USG: String?        // 건물용도 (optional)
    let CTRT_PRD: String?        // 계약기간 (optional)
    let NEW_UPDT_YN: String      // 신규갱신여부 (String으로 수정)
    let CTRT_UPDT_USE_YN: String? // 계약갱신권사용여부 (optional)
    let BFR_GRFE: String?        // 종전 보증금 (optional)
    let BFR_RTFE: String?        // 종전 임대료 (optional)
}
