//
//  CalendarViewCell.swift
//  UnivApp
//
//  Created by 정성윤 on 9/16/24.
//

import SwiftUI

struct CalendarDataCell: View {
    var model: CalendarModel
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                if let title = model.title,
                   let description = model.description,
                   let date = model.date {
                    Text(date)
                        .font(.system(size: 15, weight: .heavy))
                        .foregroundColor(Color.orange)
                    
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(title)
                            .font(.system(size: 15, weight: .heavy))
                            .foregroundColor(Color.black)
                        
                        Text(description)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color.gray)
                    }
                    
                    Spacer()
                    
                    //TODO: - 알림 등록
                    Image(systemName: "bell.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 25)
                        .foregroundColor(.gray)
                    
                }
            }
            Divider()
                .padding(.top, 10)
                .padding(.horizontal, 30)
        }
    }
}

#Preview {
    CalendarDataCell(model: CalendarModel(title: "오늘의 행사", description: "오늘의 행사", image: "emptyLogo", date: "2024-03-01"))
}
