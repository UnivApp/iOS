//
//  ToDoListView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/3/25.
//
import SwiftUI
import FSCalendar

struct ToDoListView: View {
    @State private var selectedDate = Date()

    //TODO: ViewModel - 날짜별 할 일 목록 (할 일 텍스트와 완료 여부 저장)
    @State private var toDoItems: [String: [(String, Bool)]] = [
        "2025-03-03": [("수학 문제 풀기", false), ("영어 단어 외우기", true)],
        "2025-03-04": [("체육복 챙기기", false), ("역사 숙제하기", false)]
    ]

    //TODO: Type Property
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()

    var body: some View {
        VStack(spacing: 12) {
            CalendarView(selectedDate: $selectedDate)
                .frame(height: 300)

            Text("\(formattedDate(selectedDate)) 할 일 목록")
                .font(.headline)
                .padding(.top, 8)

            List {
                if let items = toDoItems[formattedDate(selectedDate)] {
                    ForEach(items.indices, id: \.self) { index in
                        HStack {
                            Button(action: {
                                toggleComplete(for: index)
                            }) {
                                Image(systemName: items[index].1 ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(items[index].1 ? .blue.opacity(0.5) : .gray)
                            }

                            Text(items[index].0)
                                .strikethrough(items[index].1)
                                .foregroundColor(items[index].1 ? .gray : .primary)
                        }
                    }
                    .onDelete { indexSet in
                        deleteItem(at: indexSet)
                    }
                } else {
                    Text("할 일이 없습니다.")
                        .foregroundColor(.gray)
                }
            }
            .listStyle(.plain)

            Button(action: addNewToDo) {
                Text("할 일 추가")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .padding()
    }

    //TODO: ViewModel
    private func formattedDate(_ date: Date) -> String {
        dateFormatter.string(from: date)
    }

    private func addNewToDo() {
        let dateKey = formattedDate(selectedDate)
        let newItem = "새로운 할 일 \(Int.random(in: 1...100))"

        if toDoItems[dateKey] != nil {
            toDoItems[dateKey]?.append((newItem, false))
        } else {
            toDoItems[dateKey] = [(newItem, false)]
        }
    }

    private func toggleComplete(for index: Int) {
        let dateKey = formattedDate(selectedDate)
        toDoItems[dateKey]?[index].1.toggle()
    }

    private func deleteItem(at offsets: IndexSet) {
        let dateKey = formattedDate(selectedDate)
        toDoItems[dateKey]?.remove(atOffsets: offsets)

        if toDoItems[dateKey]?.isEmpty == true {
            toDoItems.removeValue(forKey: dateKey)
        }
    }
}

struct CalendarView: UIViewRepresentable {
    @Binding var selectedDate: Date

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        
        calendar.scope = .month
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.appearance.titleWeekendColor = .red
        calendar.appearance.todayColor = .systemBlue.withAlphaComponent(0.3)
        calendar.appearance.selectionColor = .systemBlue
        
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        uiView.select(selectedDate)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent: CalendarView

        init(_ parent: CalendarView) {
            self.parent = parent
        }

        func calendar(_ calendar: FSCalendar, didSelect date: Date, at position: FSCalendarMonthPosition) {
            parent.selectedDate = date
        }
    }
}

#Preview {
    ToDoListView()
}
