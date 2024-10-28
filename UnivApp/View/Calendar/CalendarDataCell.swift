//
//  CalendarViewCell.swift
//  UnivApp
//
//  Created by 정성윤 on 9/16/24.
//

import SwiftUI

struct CalendarDataCell: View {
    var model: CalendarModel
    
    @EnvironmentObject var viewModel: CalendarViewModel
    @State var bellSelected: Bool = false
    @State var isAlert: Bool
    @State var isCancel: Bool
    
    var body: some View {
        loadedView
            .alert(isPresented: $isAlert) {
                Alert(title: Text("알림 받을 날을 선택하세요! 🔔"), primaryButton: .default(Text("1일 전"), action: {
                    if let date = model.date,
                       let id = model.id {
                        viewModel.send(action: .alarmLoad([date, "\(id)"]))
                        if viewModel.phase == .success {
                            bellSelected = true
                        }
                    }
                }), secondaryButton: .default(Text("당일"), action: {
                    if let date = model.date,
                       let id = model.id {
                        viewModel.send(action: .alarmLoad([date, "\(id)"]))
                        if viewModel.phase == .success {
                            bellSelected = true
                        }
                    }
                }))
            }
            .alert(isPresented: $isCancel) {
                Alert(title: Text("알림이 취소되었습니다! 🔕"), dismissButton: .default(Text("확인"), action: {
                    viewModel.send(action: .alarmRemove)
                    if viewModel.phase == .success {
                        bellSelected = false
                    }
                }))
            }
    }
    var loadedView: some View{
        VStack {
            HStack(spacing: 20) {
                if let title = model.title,
                   let description = model.type,
                   let date = model.date,
                   let id = model.id {
                    Text(date)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color.orange)
                    
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(title)
                            .font(.system(size: 15, weight: .heavy))
                            .foregroundColor(Color.black.opacity(0.7))
                        
                        Text(description)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color.gray)
                    }
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    Button  {
                        if bellSelected {
                            isAlert = false
                            isCancel = true
                        } else {
                            isAlert = true
                            isCancel = false
                        }
                    } label: {
                        Image(systemName: "bell.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(bellSelected ? .yellow : .gray)
                    }
                }
            }
            Divider()
        }
        .padding(.horizontal, 10)
    }
}


//
//#Preview {
//    CalendarDataCell(model: CalendarModel(title: "", date: ""), bellSelected: <#T##Binding<Bool>#>)
//}
