//
//  HotPlaceSegmentView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/24/24.
//

import SwiftUI
import Kingfisher

struct HotPlaceSegmentView: View {
    var topPlaceData: [PlayModel]
    @StateObject var playViewModel = PlayViewModel(container: DIContainer(services: Services()))
    
    @State private var currentIndex: Int = 0
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center, spacing: 30) {
                TabView(selection: $currentIndex) {
                    ForEach(topPlaceData.indices, id: \.self) { index in
                        representativePlaceCell(playDetailModel: PlayDetailModel(object: playViewModel.convertToObjects(from: topPlaceData), placeDataArray: topPlaceData, placeData: topPlaceData[index]))
                            .tag(index)
                    }
                }
                .overlay(alignment: .bottomTrailing) {
                    CustomPageControl(currentPage: $currentIndex, numberOfPages: topPlaceData.count)
                        .cornerRadius(15)
                        .padding(.bottom, 10)
                        .padding(.trailing, 10)
                }
                .padding(.horizontal, 20)
                .frame(height: UIScreen.main.bounds.width * 0.7)
                .tabViewStyle(PageTabViewStyle())
                .onReceive(timer) { _ in
                    withAnimation {
                        if topPlaceData.count > 0 {
                            currentIndex = (currentIndex + 1) % topPlaceData.count
                        }
                    }
                }
                
                VStack(spacing: 20) {
                    ForEach(topPlaceData.indices, id: \.self) { index in
                        HotPlaceViewCell(model: PlayDetailModel(object: playViewModel.convertToObjects(from: topPlaceData), placeDataArray: topPlaceData, placeData: topPlaceData[index]), index: index)
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
}

struct representativePlaceCell: View {
    var playDetailModel: PlayDetailModel
    var body: some View {
        if let placeData = playDetailModel.placeData {
            NavigationLink(destination: PlayDetailView(playDetailModel: PlayDetailModel(object: playDetailModel.object, placeDataArray: playDetailModel.placeDataArray, placeData: playDetailModel.placeData))) {
                if let images = playDetailModel.placeData?.images,
                   let firstImage = images.compactMap({ $0?.imageUrl }).first{
                    KFImage(URL(string: firstImage))
                        .resizable()
                        .scaledToFill()
                        .frame(height: UIScreen.main.bounds.width * 0.7)
                        .cornerRadius(15)
                        .opacity(0.7)
                        .overlay(alignment: .bottomLeading) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("\(placeData.name)")
                                    .font(.system(size: 30, weight: .heavy))
                                
                                Text("📍 \(placeData.location)")
                                    .font(.system(size: 18, weight: .heavy))
                            }
                            .foregroundColor(.white)
                            .padding(.bottom, 50)
                            .padding(.horizontal, 20)
                        }
                }
            }
        }
    }
}

fileprivate struct HotPlaceViewCell: View {
    var model: PlayDetailModel
    var index: Int
    var body: some View {
        if let placeData = model.placeData {
            NavigationLink(destination: PlayDetailView(playDetailModel: PlayDetailModel(object: model.object, placeDataArray: model.placeDataArray, placeData: model.placeData))) {
                HStack(spacing: 30) {
                    if let images = placeData.images,
                       let firstImage = images.compactMap({ $0?.imageUrl}).first {
                        KFImage(URL(string: firstImage))
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(15)
                            .frame(width: 100, height: 100)
                            .overlay(alignment: .topLeading) {
                                ZStack(alignment: .center) {
                                    Circle()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                        .shadow(radius: 10)
                                    
                                    Text("\(index + 1)")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.orange)
                                }
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(placeData.name)
                            .font(.system(size: 15, weight: .bold))
                            .multilineTextAlignment(.leading)
                        Text(placeData.tip)
                            .font(.system(size: 12, weight: .regular))
                            .multilineTextAlignment(.leading)
                        HStack {
                            Spacer()
                            Text("📍 \(placeData.location)")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.gray)
                        }
                    }
                }.padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    HotPlaceSegmentView(topPlaceData: [PlayModel(name: "", description: "", tip: "", location: "")])
}
