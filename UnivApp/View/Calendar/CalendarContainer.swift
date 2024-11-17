//
//  CalendarContainer.swift
//  UnivApp
//
//  Created by 정성윤 on 10/17/24.
//

import SwiftUI

struct AlarmPhase {
    var isSheet: Bool
    var isSuccess: Bool
    var type: String
}

struct CalendarContainer: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: CalendarViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var isSelected: Bool = false
    @State var isAlert: Bool = false
    @State var selectedIndex: Int = 0
    @State var opacity: Bool = false
    @State var alarmPhase: AlarmPhase = .init(isSheet: false, isSuccess: false, type: "")

    var body: some View {
        contentView
            .onChange(of: viewModel.selectedCalendar) {
                self.isSelected = !viewModel.selectedCalendar.isEmpty
            }
            .onReceive(viewModel.$isAlarm) { isAlarm in
                if isAlarm == .success {
                    if viewModel.selectedCalendar[selectedIndex].notificationActive {
                        viewModel.selectedCalendar[selectedIndex].notificationActive = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            alarmPhase = AlarmPhase(isSheet: true, isSuccess: true, type: "삭제")
                        }
                    } else {
                        viewModel.selectedCalendar[selectedIndex].notificationActive = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            alarmPhase = AlarmPhase(isSheet: true, isSuccess: true, type: "등록")
                        }
                    }
                    viewModel.send(action: .totalLoad)
                    isAlert = false
                } else if isAlarm == .fail {
                    isAlert = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        alarmPhase = AlarmPhase(isSheet: true, isSuccess: false, type: "설정")
                    }
                }
            }
            .fullScreenCover(isPresented: $isAlert) {
                if viewModel.selectedCalendar[selectedIndex].notificationActive {
                    CustomAlertView(selectedIndex: $selectedIndex, isAlert: $isAlert, isSheet: $alarmPhase.isSheet, type: "삭제")
                        .environmentObject(viewModel)
                        .presentationBackground(.black.opacity(0.7))
                        .animation(.easeInOut, value: isAlert)
                } else {
                    CustomAlertView(selectedIndex: $selectedIndex, isAlert: $isAlert, isSheet: $alarmPhase.isSheet, type: "등록")
                        .environmentObject(viewModel)
                        .presentationBackground(.black.opacity(0.7))
                        .animation(.easeInOut, value: isAlert)
                }
            }
            .actionSheet(isPresented: $alarmPhase.isSheet) {
                ActionSheet(
                    title: Text("알림 \(alarmPhase.type) \(alarmPhase.isSuccess ? "성공" : "실패") 🔔"),
                    buttons: [.default(Text("확인"))]
                )
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("blackback")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                }
            }
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
                            .environmentObject(authViewModel)
                    }
                    .fadeInOut($opacity)
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
    @Binding var isSheet: Bool
    
    var type: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                Spacer()
                Button  {
                    isAlert = false
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
                Text("알림을 받으시겠습니까? 🔔")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black.opacity(0.7))
                
                Text("매일 오전 10시에 일정 알림이 보내집니다")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.gray)
                
                Button {
                    viewModel.send(action: .alarmLoad(viewModel.selectedCalendar[selectedIndex].date, viewModel.selectedCalendar[selectedIndex].calendarEventId))
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
                    viewModel.send(action: .alarmRemove(viewModel.selectedCalendar[selectedIndex].notificationId ?? 0))
                } label: {
                    Text("확인")
                        .padding(10)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 15).fill(.orange))
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 60, height: UIScreen.main.bounds.height / 3.5)
        .background(.white)
        .cornerRadius(15)
    }
}

struct CalendarContainer_Previews: PreviewProvider {
    static var previews: some View {
        CalendarContainer(viewModel: CalendarViewModel(container: .init(services: StubServices())))
            .environmentObject(AuthViewModel(container: .init(services: StubServices()), authState: .auth))
    }
}
