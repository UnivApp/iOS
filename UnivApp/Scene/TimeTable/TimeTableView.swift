//
//  TimeTableView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/17/25.
//

import SwiftUI

struct TimeTableView: View {
    @StateObject var viewModel: TimeTableViewModel = TimeTableViewModel()
    @State private var showPopup = false
    
    private let hours = Array(8...23)
    private let days = ["월", "화", "수", "목", "금", "토", "일"]
    
    var body: some View {
        ZStack {
            VStack {
                headerView
                    .padding(.horizontal, 12)
                
                timeTableGridView
            }
            .background(.lightPoint)
            
            if showPopup {
                AddSchedulePopupView(showPopup: $showPopup) { newSchedule in
                    viewModel.schedules.append(newSchedule)
                    showPopup = false
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
    }
    
    private var headerView: some View {
        HStack(alignment: .center, spacing: 12) {
            Button {
                //TODO: 개인스케줄 시간표 로드
            } label: {
                Text("개인 스케줄")
                    .font(.system(size: 15, weight: .semibold))
            }
            
            Button {
                //TODO: 학교 시간표 로드
            } label: {
                Text("학교 시간표")
                    .font(.system(size: 15, weight: .semibold))
            }
            
            Spacer()
            addScheduleButton
        }
        .padding()
    }
    
    private var addScheduleButton: some View {
        Button(action: {
            showPopup = true
        }) {
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .background(.point)
                .frame(width: 20, height: 20)
                .clipped()
                .cornerRadius(10)
        }
    }
    
    private var timeTableGridView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(
                columns: [GridItem(.fixed(30))] + Array(repeating: GridItem(.flexible()), count: 7),
                spacing: 0
            ) {
                Text("")
                    .frame(width: 30)
                
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .foregroundColor(.gray)
                        .font(.system(size: 15, weight: .semibold))
                        .frame(maxWidth: .infinity)
                }
                .padding(.bottom, 12)
                
                ForEach(hours, id: \.self) { hour in
                    Text("\(hour)")
                        .frame(width: 30)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    ForEach(days, id: \.self) { day in
                        //TODO: Filter
                        let filteredSchedules = viewModel.schedules
                        
                        TimeTableRowView(
                            day: day,
                            hour: hour,
                            schedules: filteredSchedules
                        )
                    }
                }
            }
            .padding(.all, 12)
            .background(.white)
            .clipped()
            .cornerRadius(15)
            .padding(.all, 24)
        }
    }
}


#Preview {
    TimeTableView(viewModel: TimeTableViewModel())
}
