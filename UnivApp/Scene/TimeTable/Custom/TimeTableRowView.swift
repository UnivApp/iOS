//
//  TimeTableRowView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/17/25.
//

import SwiftUI

struct TimeTableRowView: View {
    let day: String
    let hour: Int
    let schedules: [Schedule]

    let columns = [GridItem(.flexible(), spacing: 0)]

    var body: some View {
        LazyHGrid(rows: columns, spacing: 0) {
            if schedules.isEmpty {
                Text(" ")
                    .frame(minWidth: 40, maxWidth: .infinity, minHeight: 50)
                    .border(Color.gray.opacity(0.2), width: 0.5)
            } else {
                ForEach(schedules) { schedule in
                    TimeTableCellView(schedule: schedule)
                }
            }
        }
    }
}


fileprivate struct TimeTableCellView: View {
    let schedule: Schedule
    
    var body: some View {
        Text(schedule.name)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.white)
            .frame(minWidth: 40, maxWidth: .infinity, minHeight: 50)
            .background(schedule.color)
    }
}
