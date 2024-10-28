//
//  ChartData.swift
//  UnivApp
//
//  Created by 정성윤 on 9/8/24.
//

import Foundation

struct ChartData: Identifiable, Hashable {
    let id = UUID()
    let label: String
    let value: Double
    let xLabel: String
    let yLabel: String
    let year: String
}
