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
    var size: CGFloat
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Group {
                    title[0]
                        .font(.system(size: 18, weight: .bold))
                    + title[1]
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(self.pointColor)
                    + title[2]
                        .font(.system(size: 18, weight: .bold))
                }
                .padding(.top, 30)
                .padding(.leading, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(array.self, id: \.self) { item in
                            HScrollViewCell(item: item, size: self.size)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 20)
                        }
                    }
                    .padding(.leading, 10)
                }
            }
        }
    }
}

struct HScrollViewCell: View {
    var item: Object
    var size: CGFloat
    var body: some View {
        NavigationStack {
            NavigationLink(destination: PlayDetailView(viewModel: PlayDetailViewModel())) {
                VStack(spacing: 10) {
                    Image(item.image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .frame(width: self.size, height: self.size)
                    
                    Text(item.title)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    HScrollView(title: [Text("유명한 "), Text("선배 "), Text("확인하기 ")], array: [Object(title: "신혜선", image: "talent_empty"), Object(title: "신혜선", image: "talent_empty"), Object(title: "신혜선", image: "talent_empty"), Object(title: "신혜선", image: "talent_empty"), Object(title: "신혜선", image: "talent_empty")], pointColor: Color.orange, size: 30)
}
