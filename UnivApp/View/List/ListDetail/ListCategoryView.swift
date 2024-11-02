//
//  ListCategoryView.swift
//  UnivApp
//
//  Created by 정성윤 on 10/9/24.
//

import SwiftUI

struct ListCategoryView: View {
    @State private var selectedType: ListDetailType?
    @State private var isPresented: Bool = false
    @State private var opacity: Bool = false
    var universityID: Int
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("카테고리")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
            }
            .padding(.leading, 20)
            .padding(.bottom, 20)
            
            ForEach(ListDetailType.allCases, id: \.self) { type in
                Button {
                    selectedType = type
                    withAnimation {
                        self.isPresented = true
                    }
                } label: {
                    VStack {
                        Text(type.title)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(selectedType == type ? Color.gray : Color.white)
                            .frame(width: 50, height: 50)
                            .background(.clear)
                    }
                    .frame(maxWidth: 70, alignment: .center)
                    
                    HStack {
                        Group {
                            type.image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 35)
                            
                            Text(type.description)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(selectedType == type ? Color.white : Color.gray)
                        }
                        .frame(height: 50)
                        .padding(.leading, 30)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(selectedType == type ? Color.categoryGray : Color.white)
                }
                .background(selectedType == type ? Color.white : Color.categoryGray)
            }
        }
        .fullScreenCover(isPresented: $isPresented) {
            self.selectedType?.view
                .fadeInOut($opacity)
        }
        .transaction { $0.disablesAnimations = true }
    }
}

#Preview {
    ListCategoryView(universityID: 0)
}
