//
//  HScrollView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/6/24.
//

import SwiftUI

struct HScrollView: View {
    var title: [Text]
    var array: [Object]
    var pointColor: Color
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Group {
                    title[0]
                        .font(.system(size: 15, weight: .bold))
                    + title[1]
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(self.pointColor)
                    + title[2]
                        .font(.system(size: 15, weight: .bold))
                }
                .padding(.top, 30)
                .padding(.horizontal, 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(array.self, id: \.self) { item in
                            VStack(spacing: 10) {
                                Image(item.image)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(10)
                                    .frame(width: 100, height: 100)
                                
                                Text(item.title)
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.black)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 20)
                        }
                    }
                }
            }
            .padding(.leading, 30)
        }
    }
}

#Preview {
    HScrollView(title: [Text("유명한 "), Text("선배 "), Text("확인하기 ")], array: [Object(title: "신혜선", image: "talent_empty"), Object(title: "신혜선", image: "talent_empty"), Object(title: "신혜선", image: "talent_empty"), Object(title: "신혜선", image: "talent_empty"), Object(title: "신혜선", image: "talent_empty")], pointColor: Color.orange)
}
