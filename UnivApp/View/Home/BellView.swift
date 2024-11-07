//
//  BellView.swift
//  UnivApp
//
//  Created by 정성윤 on 11/1/24.
//

import SwiftUI

struct BellView: View {
    @StateObject var viewModel: CalendarViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var isPopup: Bool
    
    @State private var isAlert: Bool = false
    @State private var ScrollIndex: Int = 0
    @State var alarmPhase: AlarmPhase = .init(isSheet: false, isSuccess: false, type: "")
    
    var body: some View {
        contentView
            .onReceive(viewModel.$isAlarm) { isAlarm in
                if isAlarm == .success {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        alarmPhase = AlarmPhase(isSheet: true, isSuccess: true, type: "등록")
                    }
                    viewModel.send(action: .getAlarm)
                } else if isAlarm == .fail {
                    isAlert = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        alarmPhase = AlarmPhase(isSheet: true, isSuccess: false, type: "삭제")
                    }
                }
            }
            .actionSheet(isPresented: $alarmPhase.isSheet) {
                ActionSheet(
                    title: Text("알림 삭제 \(alarmPhase.isSuccess ? "성공" : "실패") 🔔"),
                    buttons: [.default(Text("확인"))]
                )
            }
            .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear {
                    viewModel.send(action: .getAlarm)
                }
        case .loading:
            LoadingView(url: "congratulations", size: [150, 150])
        case .success:
            loadedView
                .refreshable {
                    viewModel.send(action: .getAlarm)
                }
        case .fail:
            ErrorView()
        }
    }
    var loadedView: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        self.isPopup = false
                        dismiss()
                    }
                } label: {
                    Image("close_black")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    if viewModel.alarmData.isEmpty {
                        Text("설정된 알림이 없어요! 🔕")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.black.opacity(0.7))
                    } else {
                        ForEach(viewModel.alarmData.indices, id: \.self) { index in
                            AlarmDataCell(selectedIndex: $ScrollIndex, model: viewModel.alarmData[index], index: index)
                                .environmentObject(viewModel)
                                .id(index)
                        }
                    }
                }
                .onChange(of: viewModel.alarmData.count) {
                    proxy.scrollTo(ScrollIndex, anchor: .center)
                }
            }
        }
        .background(.white)
    }
}

fileprivate struct AlarmDataCell: View {
    @EnvironmentObject var viewModel: CalendarViewModel
    @Binding var selectedIndex: Int
    var model: AlarmListModel
    var index: Int
    
    var body: some View {
        loadedView
    }
    var loadedView: some View{
        VStack {
            HStack(spacing: 20) {
                Text(model.notificationDate)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color.orange)
                
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(model.title)
                        .font(.system(size: 15, weight: .heavy))
                        .foregroundColor(Color.black.opacity(0.7))
                    
                    Text(model.type)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color.gray)
                }
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                Button  {
                    viewModel.send(action: .alarmRemove(model.notificationId))
                    selectedIndex = index
                } label: {
                    Image(systemName: "bell.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(model.active ? .yellow : .gray)
                }
            }
            Divider()
        }
        .padding(.horizontal, 20)
    }
    
}


struct BellView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isAlert: Bool = false
        BellView(viewModel: CalendarViewModel(container: .init(services: StubServices())), isPopup: $isAlert)
    }
}
