//
//  FoodViewCell.swift
//  UnivApp
//
//  Created by 정성윤 on 9/6/24.
//

import SwiftUI

struct FoodViewCell: View {
    var title: String
    var description: String
    var image: String
    var school: String
    var view: AnyView
    
    var body: some View {
        NavigationStack {
            NavigationLink(destination: view) {
                HStack {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .overlay(alignment: .topLeading) {
                            Image("sort")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .shadow(radius: 10)
                        }
                    
                    VStack(alignment: .center, spacing: 5) {
                        Text(description)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.black)
                        
                        Text(title)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                        
                        HStack {
                            Spacer()
                            Text(school)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.bottom, 10)
                .padding(.horizontal, 30)
            }
            Divider()
                .background(Color.gray)
                .padding(.horizontal, 30)
        }
    }
}

#Preview {
    FoodViewCell(title: "", description: "", image: "", school: "", view: AnyView(Text("")))
}
