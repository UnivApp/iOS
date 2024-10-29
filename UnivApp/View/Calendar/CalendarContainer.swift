//
//  CalendarContainer.swift
//  UnivApp
//
//  Created by 정성윤 on 10/17/24.
//

import SwiftUI

struct CalendarContainer: View {
    @StateObject var viewModel: CalendarViewModel
    @State var isSelected: Bool = false
    @State var opacity: Double = 0
    
    @State var isAlert: Bool = false
    @State var isCancel: Bool = false
    @State var selectedIndex: Int = 0

    var body: some View {
        contentView
            .onChange(of: viewModel.selectedCalendar) {
                self.isSelected = !viewModel.selectedCalendar.isEmpty
            }
            .fullScreenCover(isPresented: $isAlert) {
                if viewModel.selectedCalendar[selectedIndex].notificationActive {
                    CustomAlertView(selectedIndex: $selectedIndex, isAlert: $isAlert, type: "삭제")
                        .environmentObject(viewModel)
                        .presentationBackground(.black.opacity(0.7))
                        .animation(.easeInOut, value: isAlert)
                } else {
                    CustomAlertView(selectedIndex: $selectedIndex, isAlert: $isAlert, type: "등록")
                        .environmentObject(viewModel)
                        .presentationBackground(.black.opacity(0.7))
                        .animation(.easeInOut, value: isAlert)
                }
            }
            .actionSheet(isPresented: $viewModel.isalarmSetting.isAlarmFail) {
                ActionSheet(
                    title: Text("알림 \(viewModel.isalarmSetting.selectedType) 실패! 😔"),
                    buttons: [.default(Text("확인"))]
                )
            }
            .actionSheet(isPresented: $viewModel.isalarmSetting.isAlarmSuccess) {
                ActionSheet(
                    title: Text("알림 \(viewModel.isalarmSetting.selectedType) 성공! 😊"),
                    buttons: [.default(Text("확인"))]
                )
            }
            .transaction { $0.disablesAnimations = true }
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear {
                    viewModel.send(action: .totalLoad)
                }
        case .loading:
            LoadingView(url: "congratulations", size: [150, 150])
        case .success:
            loadedView
                .refreshable {
                    viewModel.send(action: .totalLoad)
                    viewModel.selectedCalendar = []
                }
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 20) {
                    CalendarView(calenderData: viewModel.calendarData, selectedData: $viewModel.selectedCalendar)
                        .frame(height: isSelected ? UIScreen.main.bounds.height / 1.7 : UIScreen.main.bounds.height / 1.2)
                        .animation(.easeInOut, value: isSelected)
                        .padding(.horizontal, -10)
                    
                    ForEach(viewModel.selectedCalendar.indices, id: \.self) { index in
                        CalendarDataCell(model: CalendarDetailModel(model: viewModel.selectedCalendar[index], bellSelected: viewModel.selectedCalendar[index].notificationActive, index: index), selectedIndex: self.$selectedIndex, isAlert: $isAlert)
                    }
                    .onAppear {
                        opacity = 1
                    }
                    .onDisappear {
                        opacity = 0
                    }
                    .opacity(opacity)
                    .animation(.easeInOut, value: opacity)
                }
                .padding(.horizontal, 20)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("logo")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.send(action: .totalLoad)
                    } label: {
                        ZStack {
                            Image("refresh")
                                .padding()
                        }
                        .frame(width: 30, height: 30)
                        .background(Color.backGray)
                        .clipShape(Circle())
                    }
                }
            }
        }
    }
}

fileprivate struct CustomAlertView: View {
    @EnvironmentObject var viewModel: CalendarViewModel
    @Binding var selectedIndex: Int
    @Binding var isAlert: Bool
    
    var type: String
    var buttonTypes: [String] = ["1일 전", "당일"]
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            HStack {
                Spacer()
                Button  {
                    withAnimation {
                        isAlert = false
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.gray)
                }
            }
            .padding(.trailing, 20)
            
            if type == "등록" {
                Text("알림 받을 날을 선택하세요! 🔔")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black.opacity(0.7))
                
                Button {
                    if let date = viewModel.selectedCalendar[selectedIndex].date,
                       let calendarId = viewModel.selectedCalendar[selectedIndex].calendarEventId,
                       let previousDate = viewModel.calculatePreviousDate(from: date) {
                        if viewModel.phase == .success {
                            viewModel.selectedCalendar[selectedIndex].notificationActive = true
                            isAlert = false
                        }
                    }
                } label: {
                    Text("확인")
                        .padding(10)
                        .font(.system(size: 13, weight: .heavy))
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 15).fill(.orange))
                }
            } else {
                Text("알림을 취소하시겠습니까? 🔕")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black.opacity(0.7))
                
                Button {
                    if let notificationId = viewModel.selectedCalendar[selectedIndex].notificationId {
                        viewModel.send(action: .alarmRemove("\(notificationId)"))
                        if viewModel.phase == .success {
                            viewModel.selectedCalendar[selectedIndex].notificationActive = false
                            isAlert = false
                        }
                    }
                } label: {
                    Text("확인")
                        .padding(10)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 15).fill(.orange))
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 60, height: UIScreen.main.bounds.height / 4)
        .background(.white)
        .cornerRadius(15)
    }
}

struct CalendarContainer_Previews: PreviewProvider {
    static var previews: some View {
        CalendarContainer(viewModel: CalendarViewModel(container: .init(services: StubServices())))
    }
}
