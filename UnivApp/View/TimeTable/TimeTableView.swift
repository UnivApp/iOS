//
//  TimeTableView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/2/25.
//

import SwiftUI

struct TimeTableView: View {
    let days = ["월", "화", "수", "목", "금"]
    let hours = (6..<26).map { hour -> String in
        let adjustedHour = hour >= 24 ? hour - 24 : hour
        return String(format: "%2d시", adjustedHour)
    }
    
    @State private var schedule: [String: [String: String]] = [
        "월": ["9시": "수학", "14시": "영어"],
        "화": ["10시": "체육"],
        "수": [:],
        "목": ["13시": "과학"],
        "금": [:],
        "토": [:],
        "일": [:]
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                cellView(text: "시간", background: Color.blue.opacity(0.5), color: .white, bold: true)

                ForEach(days, id: \.self) { day in
                    cellView(
                        text: day,
                        background: Color.blue.opacity(0.5),
                        color: .white,
                        bold: true
                    )
                }
            }

            ScrollView(.vertical) {
                LazyVGrid(columns: [GridItem(.fixed(50))] + Array(repeating: GridItem(.flexible()), count: 5), spacing: 0) {
                    ForEach(hours, id: \.self) { hour in
                        
                        cellView(
                            text: hour,
                            background: .white,
                            color: .gray
                        )
                        
                        ForEach(days, id: \.self) { day in
                            ZStack {
                                if let event = schedule[day]?[hour] {
                                    Text(event)
                                        .foregroundColor(.black)
                                } else {
                                    Text("")
                                }

                            }
                        }
                    }
                }
            }
        }
    }

    private func cellView(text: String, background: Color, color: Color, bold: Bool = false) -> some View {
        VStack {
            Text(text)
                .font(.system(size: 15, weight: .semibold))
                .frame(maxWidth: 100, minHeight: 100)
                .background(background)
                .foregroundColor(color)
        }
    }
}



struct TimetableView_Previews: PreviewProvider {
    static var previews: some View {
        TimeTableView()
    }
}
