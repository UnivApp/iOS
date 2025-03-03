//
//  TimeTableView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/2/25.
//

import SwiftUI
import FSCalendar

struct TimeTableView: View {
    let days = ["월", "화", "수", "목", "금", "토", "일"]
    let hours = (6..<26).map { hour -> String in
        let adjustedHour = hour >= 24 ? hour - 24 : hour
        return String(format: "%2d시", adjustedHour)
    }
    
    @State private var schedule: [String: [String: String]] = [
        "월": ["09:00": "수학", "14:00": "영어"],
        "화": ["10:00": "체육"],
        "수": [:],
        "목": ["13:00": "과학"],
        "금": [:],
        "토": [:],
        "일": [:]
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // 요일 헤더
            HStack(spacing: 0) {
                cellView(text: "시간", background: Color.blue.opacity(0.5), color: .white, bold: true)
                    .frame(width: 50)

                ForEach(days, id: \.self) { day in
                    cellView(
                        text: day,
                        background: Color.blue.opacity(0.5),
                        color: .white,
                        bold: true
                    )
                }
            }

            // 시간표 본문
            List {
                LazyVGrid(columns: [GridItem(.fixed(50))] + Array(repeating: GridItem(.flexible()), count: 7), spacing: 0) {
                    ForEach(hours, id: \.self) { hour in
                        
                        cellView(
                            text: hour,
                            background: hourColor(for: hour),
                            color: .black
                        )
                        
                        ForEach(days, id: \.self) { day in
                            ZStack {
                                Rectangle()
                                    .fill(cellBackgroundColor(day: day, hour: hour))
                                    .border(Color.gray.opacity(0.5), width: 0.5)

                                if let event = schedule[day]?[hour] {
                                    Text(event)
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.black)
                                } else {
                                    Text("")
                                }

                                Button("") {
                                    addActivity(for: hour, on: day)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
    }

    // 셀 기본 뷰
    func cellView(text: String, background: Color, color: Color, bold: Bool = false) -> some View {
        VStack {
            Text(text)
                .font(.system(size: 18, weight: .semibold))
                .frame(maxWidth: 100, minHeight: 100)
                .background(background)
                .foregroundColor(color)
        }
        .frame(height: 100)
    }

    // 현재 시간 칸 강조
    func hourColor(for hour: String) -> Color {
        let currentHour = Calendar.current.component(.hour, from: Date())
        let formattedCurrentHour = String(format: "%02d:00", currentHour)
        return hour == formattedCurrentHour ? Color.yellow.opacity(0.5) : Color.white
    }

    // 요일 헤더 컬러
    func dayBackgroundColor(_ day: String) -> Color {
        return ["토", "일"].contains(day) ? Color.orange.opacity(0.7) : Color.blue.opacity(0.8)
    }
    
    // 표 안쪽 칸 배경 (주말은 살짝 다르게)
    func cellBackgroundColor(day: String, hour: String) -> Color {
        if ["토", "일"].contains(day) {
            return Color.orange.opacity(0.1)
        } else {
            return Color.white
        }
    }

    // 일정 추가 기능 (테스트용)
    func addActivity(for hour: String, on day: String) {
        schedule[day, default: [:]][hour] = "새 일정"
    }
}



struct TimetableView_Previews: PreviewProvider {
    static var previews: some View {
        TimeTableView()
    }
}
