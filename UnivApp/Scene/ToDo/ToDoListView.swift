//
//  ToDoListView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/17/25.
//

import SwiftUI
import FSCalendar

struct ToDoListView: View {
    @StateObject var viewModel: ToDoListViewModel
    @State private var selectedDate = Date()
    @State private var calendarScope: FSCalendarScope = .month
    @State private var previousOffset: CGFloat = 0

    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()

    var body: some View {
        VStack(spacing: 12) {
            GeometryReader { geometry in
                ScrollView {
                    CalendarView(selectedDate: $selectedDate, calendarScope: $calendarScope)
                        .frame(height: calendarScope == .month ? 300 : 100)
                        .animation(.easeInOut, value: calendarScope)
                        .background(.white)
                        .clipped()
                        .cornerRadius(15)
                        .onAppear {
                            previousOffset = geometry.frame(in: .global).minY
                        }
                        .onChange(of: geometry.frame(in: .global).minY) { newOffset in
                            if previousOffset > newOffset {
                                // 위로 스크롤 시 month로 변경
                                if calendarScope != .month {
                                    calendarScope = .month
                                }
                            } else if previousOffset < newOffset {
                                if calendarScope != .week {
                                    calendarScope = .week
                                }
                            }
                            previousOffset = newOffset
                        }
                }
            }
            .frame(height: 300)

            List {
                let dateKey = formattedDate(selectedDate)
                if let items = viewModel.toDoItems[dateKey] {
                    ForEach(items.indices, id: \.self) { index in
                        HStack {
                            Button(action: {
                                viewModel.toggleComplete(for: dateKey, index: index)
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
                        viewModel.deleteItem(for: dateKey, at: indexSet)
                    }
                } else {
                    Text("할 일이 없습니다.")
                        .foregroundColor(.gray)
                }
            }
            .listStyle(.plain)
            .background(.white)
            .clipped()
            .cornerRadius(15)

            Button(action: addNewToDo) {
                Text("할 일 추가")
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(.primary)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
            }
        }
        .padding(.horizontal, 24)
        .background(.white)
    }

    private func formattedDate(_ date: Date) -> String {
        dateFormatter.string(from: date)
    }

    private func addNewToDo() {
        let dateKey = formattedDate(selectedDate)
        viewModel.addNewToDoItem(for: dateKey)
    }
}


struct CalendarView: UIViewRepresentable {
    @Binding var selectedDate: Date
    @Binding var calendarScope: FSCalendarScope

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
        uiView.scope = calendarScope
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
