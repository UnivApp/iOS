//
//  CalendarViewCell.swift
//  UnivApp
//
//  Created by 정성윤 on 9/16/24.
//

import SwiftUI

struct CalendarDataCell: View {
    var model: CalendarModel
    
    @State var bellSelected: Bool = false
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                if let title = model.title,
                   let description = model.type,
                   let date = model.date {
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
                        bellSelected.toggle()
                        //TODO: - 알림설정
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

#Preview {
    CalendarDataCell(model: CalendarModel(title: "", date: ""))
}
