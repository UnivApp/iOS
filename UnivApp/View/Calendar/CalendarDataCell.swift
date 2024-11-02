//
//  CalendarViewCell.swift
//  UnivApp
//
//  Created by 정성윤 on 9/16/24.
//

import SwiftUI

struct CalendarDetailModel: Hashable {
    var model: CalendarModel
    var bellSelected: Bool
    var index: Int
}

struct CalendarDataCell: View {
    var model: CalendarDetailModel
    
    @Binding var selectedIndex: Int
    @Binding var isAlert: Bool
    
    var body: some View {
        loadedView
    }
    var loadedView: some View{
        VStack {
            HStack(spacing: 20) {
                Text(model.model.date)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color.orange)
                
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(model.model.title)
                        .font(.system(size: 15, weight: .heavy))
                        .foregroundColor(Color.black.opacity(0.7))
                    
                    Text(model.model.type)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color.gray)
                }
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                Button  {
                    withAnimation {
                        isAlert = true
                        selectedIndex = model.index
                    }
                } label: {
                    Image(systemName: "bell.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(model.bellSelected ? .yellow : .gray)
                }
            }
            Divider()
        }
        .padding(.horizontal, 10)
    }
    
}
