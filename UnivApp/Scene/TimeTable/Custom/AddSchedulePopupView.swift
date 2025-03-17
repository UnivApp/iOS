//
//  AddSchedulePopupView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/17/25.
//

import SwiftUI

struct AddSchedulePopupView: View {
    @State private var name: String = ""
    @State private var selectedColor: Color = .blue
    @State private var selectedDay: String = "월"
    @State private var selectedHour: Int = 9
    @Binding var showPopup: Bool

    var onSave: (Schedule) -> Void

    private let days: [String] = ["월", "화", "수", "목", "금", "토", "일"]
    private let colors: [Color] = [Color.blue, Color.green, Color.red, Color.purple, Color.orange]

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("새 일정 추가")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.black)

            scheduleNameField

            colorSelection

            daySelection

            timeSelection

            actionButtons
        }
        .padding()
        .frame(width: 300)
        .background(.lightPoint)
        .cornerRadius(10)
        .shadow(radius: 2)
    }

    private var scheduleNameField: some View {
        TextField("일정 제목", text: $name)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }

    private var colorSelection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("컬러 선택")
                .font(.system(size: 12, weight: .semibold))
            HStack {
                ForEach(colors, id: \.self) { color in
                    Circle()
                        .fill(color)
                        .frame(width: 24, height: 24)
                        .onTapGesture { selectedColor = color }
                        .overlay(Circle().stroke(selectedColor == color ? Color.gray : Color.clear, lineWidth: 2))
                }
            }
        }
    }

    private var daySelection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("요일 선택")
                .font(.system(size: 12, weight: .semibold))
            Picker("요일", selection: $selectedDay) {
                ForEach(days, id: \.self) { day in
                    Text(day).tag(day)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }

    private var timeSelection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("시간 선택")
                .font(.system(size: 12, weight: .semibold))
            Picker("시간", selection: $selectedHour) {
                ForEach(8..<24, id: \.self) { hour in
                    Text("\(hour):00").tag(hour)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }

    private var actionButtons: some View {
        HStack {
            Button(action: {
                let newSchedule = Schedule(name: name, color: selectedColor, days: [selectedDay], time: "\(selectedHour):00")
                onSave(newSchedule)
            }) {
                Text("저장")
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .background(.point)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }

            Button(action: {
                showPopup = false
            }) {
                Text("취소")
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .background(Color.gray.opacity(0.3))
                    .foregroundColor(.black)
                    .cornerRadius(5)
            }
        }
    }
}
