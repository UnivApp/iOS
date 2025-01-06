//
//  HScrollView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/6/24.
//

import SwiftUI
import Kingfisher
struct HScrollView: View {
    var title: [Text]
    var pointColor: Color
    var size: CGFloat
    var playDetailModel: PlayDetailModel
    
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
                    LazyHStack(spacing: 0) {
                        ForEach(playDetailModel.object.self, id: \.self) { item in
                            HScrollViewCell(item: item, size: self.size, playDetailModel: PlayDetailModel(object: playDetailModel.object, placeDataArray: playDetailModel.placeDataArray, placeData: playDetailModel.placeData))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 20)
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }
        }
    }
}

struct HScrollViewCell: View {
    var item: Object
    var size: CGFloat
    var playDetailModel: PlayDetailModel
    
    var body: some View {
        NavigationStack {
            if let selectedPlace = playDetailModel.placeDataArray.first(where: { $0.name == item.title }) {
                NavigationLink(destination: PlayDetailView(playDetailModel: PlayDetailModel(object: playDetailModel.object, placeDataArray: playDetailModel.placeDataArray, placeData: selectedPlace))) {
                    VStack(spacing: 10) {
                        KFImage(URL(string: item.image))
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
}

