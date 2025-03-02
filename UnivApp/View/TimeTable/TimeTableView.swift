//
//  TimeTableView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/2/25.
//

import SwiftUI

struct TimeTableView: View {
    let daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"]
    @State private var schedule: [String: [String]] = [
        "월": ["9:00 AM - 수학", "2:00 PM - 영어"],
        "화": ["10:00 AM - 체육", "1:00 PM - 역사"]
    ]
    
    var body: some View {
        VStack {
            // 요일 헤더
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }
            .padding()

            // 24시간 시간표 (시간대별로 표시)
            LazyVStack {
                ForEach(0..<24, id: \.self) { hour in
                    HStack {
                        Text("\(hour < 10 ? "0" : "")\(hour):00")
                            .frame(width: 60, alignment: .leading)
                            .padding(.leading)
                        
                        ForEach(daysOfWeek, id: \.self) { day in
                            VStack {
                                Text(schedule[day]?.first { event in
                                    event.contains("\(hour):00") } ?? "-")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(5)

                                // 활동 추가 버튼
                                Button(action: {
                                    addActivity(for: day, at: hour)
                                }) {
                                    Text("추가")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                        .padding(5)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(5)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 1)
                }
            }
        }
        .padding()
    }

    func addActivity(for day: String, at hour: Int) {
        let newActivity = "\(hour < 10 ? "0" : "")\(hour):00 - 새 활동"
        if schedule[day] != nil {
            schedule[day]?.append(newActivity)
        } else {
            schedule[day] = [newActivity]
        }
    }
}


#Preview {
    TimeTableView()
}
