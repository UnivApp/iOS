//
//  CalendarView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/13/24.
//

import Foundation
import SwiftUI
import FSCalendar
import SnapKit

struct CalendarView: UIViewRepresentable {
    typealias UIViewType = FSCalendar
    var eventImages: [Date: UIImage]
    var eventDateRange: [Date] {
        let calendar = Calendar.current
        let today = Date()
        
        let day1 = today
        let day2 = calendar.date(byAdding: .day, value: 1, to: today)!
        let day3 = calendar.date(byAdding: .day, value: 2, to: today)!
        
        return [day1, day2, day3]
    }
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent: CalendarView
        
        init(_ parent: CalendarView) {
            self.parent = parent
        }
        
        
        func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
            let cell = calendar.dequeueReusableCell(withIdentifier: "CalendarViewCell", for: date, at: position) as! CalendarViewCell
            
            
            if let eventImage = parent.eventImages[date] {
                cell.setEventImage(date: date, image: eventImage)
            } else {
                cell.setEventImage(date: date, image: nil)
            }
            return cell
        }
        
        // 날짜 범위를 강조
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillFor date: Date) -> UIColor? {
            // 날짜가 이벤트 범위에 있는 경우 형광펜 효과
            if parent.eventDateRange.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) {
                return UIColor.yellow.withAlphaComponent(0.5) // 형광펜 효과
            }
            return nil
        }
        
        // 날짜에 대한 텍스트 색상 조정 (형광펜 효과에 맞춰 텍스트 색상 변경)
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
            if parent.eventDateRange.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) {
                return .black // 이벤트 날짜의 텍스트 색상을 검정으로
            }
            return nil
        }
    }
    
    
    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        calendar.locale = Locale(identifier: "ko_KR")
        
        calendar.today = nil
        calendar.scrollDirection = .horizontal
        calendar.scope = .month
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.weekdayTextColor = .orange
        calendar.appearance.selectionColor = .clear
        calendar.appearance.titleSelectionColor = .systemRed
        
        
        calendar.register(CalendarViewCell.self, forCellReuseIdentifier: "CalendarViewCell")
        
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}

class CalendarViewCell: FSCalendarCell {
    private var eventImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
    }
    
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        configureImageView()
    }
    
    private func configureImageView() {
        let width = contentView.bounds.width - 5
        let height = contentView.bounds.height - 5
        
        let size = (width > height) ? height : width
        eventImageView = UIImageView()
        eventImageView.contentMode = .scaleAspectFit
        eventImageView.alpha = 0.5
        
        contentView.addSubview(eventImageView)
        eventImageView.snp.makeConstraints { make in
            make.width.height.equalTo(size)
            make.center.equalToSuperview()
        }
    }
    
    func setEventImage(date: Date, image: UIImage?) {
        eventImageView.image = image
    }
}

struct CalendarContainer: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: CalendarViewModel
    
    var eventDates: [Date: UIImage] //TODO: - 실제 데이터 변환
    
    var body: some View {
        contentView
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            loadedView
                .onAppear {
                    //TODO: - send(load)
                }
        case .loading:
            LoadingView(url: "congratulations", size: [150, 150])
        case .success:
            loadedView
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        NavigationStack {
            GeometryReader { proxy in
                ScrollView(.vertical) {
                    VStack {
                        CalendarView(eventImages: eventDates)
                            .frame(height: proxy.size.height / 1.5)
                            .padding(.horizontal, 20)
                        
                        ForEach(viewModel.calendarData, id: \.title) { item in
                            CalendarDataCell(model: item)
                        }
                        .padding(.horizontal, 30)
                    }
                }
            }
        }
    }
}

struct CalendarContainer_Previews: PreviewProvider {
    static var previews: some View {
        CalendarContainer(viewModel: CalendarViewModel(), eventDates: [
            Calendar.current.startOfDay(for: Date()): UIImage(named: "star")!
        ])
        .environmentObject(AuthViewModel(container: .init(services: StubServices()), authState: .auth))
    }
}
