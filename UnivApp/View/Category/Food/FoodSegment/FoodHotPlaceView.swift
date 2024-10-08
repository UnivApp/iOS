//
//  FoodHotPlaceView.swift
//  UnivApp
//
//  Created by 정성윤 on 10/7/24.
//

import SwiftUI
import Kingfisher

struct FoodHotPlaceView: View {
    var model: [FoodModel]
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            HStack {
                Text("대학 주변 ")
                + Text("맛집")
                    .foregroundColor(.orange)
                + Text(" 확인하기")
                Spacer()
            }
            .font(.system(size: 18, weight: .bold))
            .padding(.horizontal, 30)
            
            ScrollView(.vertical) {
                ForEach(model, id: \.self) { cell in
                    FoodHotPlaceCell(cell: cell)
                }
            }
        }
    }
}

fileprivate struct FoodHotPlaceCell: View {
    var cell: FoodModel
    
    @State private var scrollOffset: CGFloat = 0
    @State private var timer: Timer? = nil
    @State private var isScrollingRight = true
    private let scrollDuration: TimeInterval = 5.0
    
    var body: some View {
        HStack(spacing: 20) {
            KFImage(URL(string: cell.imageUrl ?? ""))
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .background(.backGray)
                .cornerRadius(15)
            
            Spacer()
            
            VStack(alignment: .center, spacing: 10) {
                Text(cell.name)
                    .font(.system(size: 18, weight: .bold))
                
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 5) {
                            ForEach(cell.hashtags, id: \.self) { hashtag in
                                Text("#\(hashtag)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .padding(5)
                                    .background(Color.yellow.opacity(0.3))
                                    .cornerRadius(5)
                            }
                        }
                        .offset(x: scrollOffset)
                        .onAppear {
                            startScrolling(geometry: geometry)
                        }
                        .onDisappear {
                            stopScrolling()
                        }
                    }
                }
                .frame(height: 30)

                
                HStack {
                    Text("📍 \(cell.topMessage)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
        }.padding(.horizontal, 30)
    }
    
    private func startScrolling(geometry: GeometryProxy) {
        let maxOffset = geometry.size.width
        let totalWidth = CGFloat(cell.hashtags.count) * 80
        let offsetLimit = totalWidth - maxOffset
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            withAnimation(.linear(duration: 0.02)) {
                if isScrollingRight {
                    scrollOffset -= 1
                    if -scrollOffset >= offsetLimit {
                        isScrollingRight = false
                    }
                } else {
                    scrollOffset += 1
                    if scrollOffset >= 0 {
                        isScrollingRight = true
                    }
                }
            }
        }
    }
    
    private func stopScrolling() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    FoodHotPlaceView(model: [FoodModel(name: "깍뚝", location: "서울특별시 광진구 동일로", placeUrl: "", hashtags: ["삼겹살", "가브리살", "무한리필"], imageUrl: "", topMessage: "세종대학교 1등 맛집")])
}
