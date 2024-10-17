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
    var calenderData: [CalendarModel]
    
    @Binding var selectedData: [CalendarModel]
    
    var groupedData: [Date: [CalendarModel]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var grouped: [Date: [CalendarModel]] = [:]
        
        for model in calenderData {
            if let dateString = model.date, let date = dateFormatter.date(from: dateString) {
                if grouped[date] != nil {
                    grouped[date]?.append(model)
                } else {
                    grouped[date] = [model]
                }
            }
        }
        return grouped
    }
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent: CalendarView
        
        init(_ parent: CalendarView) {
            self.parent = parent
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            if let data = parent.groupedData[date] {
                self.parent.selectedData = data
            }
        }
        
        func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
            let cell = calendar.dequeueReusableCell(withIdentifier: "CalendarViewCell", for: date, at: position) as! CalendarViewCell
            
            if let events = parent.groupedData[date], let eventImage = UIImage(named: "calendar_icon"), !events.isEmpty {
                cell.setEventImage(date: date, image: eventImage)
            } else {
                cell.setEventImage(date: date, image: nil)
            }
            return cell
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
        eventImageView = UIImageView()
        eventImageView.contentMode = .scaleAspectFit
        eventImageView.alpha = 1.0
        
        contentView.addSubview(eventImageView)
        eventImageView.snp.makeConstraints { make in
            make.width.height.equalTo(5)
            make.bottom.equalToSuperview().inset(5)
            make.centerX.equalToSuperview()
        }
    }
    
    func setEventImage(date: Date, image: UIImage?) {
        eventImageView.image = image
    }
}
