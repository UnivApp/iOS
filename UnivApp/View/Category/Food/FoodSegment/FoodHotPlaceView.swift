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
    
    @State private var isPresented: Bool = false
    @State private var selectedModel: FoodModel?
    @State private var isFullCover: Bool = false
    @State private var popupOpacity: Double = 0
    
    var body: some View {
        loadedView
            .fullScreenCover(isPresented: $isPresented) {
                if let model = selectedModel {
                    FoodSelectedPopupView(model: model, isPresented: $isPresented, isFullCover: $isFullCover)
                        .presentationBackground(.black.opacity(0.3))
                        .onAppear {
                            withAnimation {
                                popupOpacity = 1
                            }
                        }
                        .onDisappear {
                            withAnimation {
                                popupOpacity = 0
                            }
                        }
                        .opacity(popupOpacity)
                        .animation(.easeInOut, value: popupOpacity)
                }
            }
            .background(isPresented ? .black.opacity(0.3) : .white)
            .fullScreenCover(isPresented: $isFullCover) {
                if let model = selectedModel {
                    MapView(model: model, isPopup: true, isCover: true)
                        .presentationBackground(.black.opacity(0.3))
                        .onAppear {
                            withAnimation {
                                popupOpacity = 1
                            }
                        }
                        .onDisappear {
                            withAnimation {
                                popupOpacity = 0
                            }
                        }
                        .opacity(popupOpacity)
                        .animation(.easeInOut, value: popupOpacity)
                }
            }
            .transaction { $0.disablesAnimations = true }
    }
    
    var loadedView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 20) {
                Image("food_poster")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width)
                
                HStack {
                    Text("대학별 ")
                    + Text("1등👑 맛집")
                        .foregroundColor(.orange)
                    + Text(" 확인하기")
                    Spacer()
                }
                .font(.system(size: 18, weight: .bold))
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
                
                ForEach(model.indices, id: \.self) { index in
                    VStack {
                        FoodHotPlaceCell(cell: model[index], isPresented: $isPresented, selectedModel: $selectedModel, isFullCover: $isFullCover)
                            .id(index)
                            .padding(.vertical, -5)
                    }
                }
            }
        }
    }
}

fileprivate struct FoodHotPlaceCell: View {
    var cell: FoodModel
    
    @State private var scrollOffset: CGFloat = 20
    @State private var timer: Timer? = nil
    @State private var isScrollingRight = true
    
    private let scrollDuration: TimeInterval = 5.0
    
    @Binding var isPresented: Bool
    @Binding var selectedModel: FoodModel?
    @Binding var isFullCover: Bool
    
    var body: some View {
        loadedView
    }
    
    var loadedView: some View {
        Button {
            self.selectedModel = cell
            withAnimation {
                self.isPresented = true
            }
        } label: {
            HStack(spacing: 20) {
                MapView(model: cell, isPopup: false, isCover: false)
                    .frame(width: 80, height: 80)
                    .cornerRadius(15)
                    .allowsHitTesting(false)
                    .overlay {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(isPresented ? Color.black.opacity(0.3) : Color.clear)
                    }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 10) {
                    Text(cell.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    GeometryReader { geometry in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 5) {
                                ForEach(cell.hashtags, id: \.self) { hashtag in
                                    Text("#\(hashtag)")
                                        .font(.system(size: 14, weight: .semibold))
                                        .padding(5)
                                        .background(Color.yellow.opacity(0.3))
                                        .foregroundColor(.black)
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
                    
                    if let address = cell.topMessage {
                        HStack {
                            Text("📍 \(address)")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.gray)
                                .lineLimit(1)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
        }
    }
    
    private func startScrolling(geometry: GeometryProxy) {
        let maxOffset = geometry.size.width
        let totalWidth = calculateTotalHashtagWidth() + CGFloat(cell.hashtags.count) * 20
        
        if totalWidth <= maxOffset {
            return
        }
        
        let offsetLimit = totalWidth - maxOffset
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            withAnimation(.linear(duration: 0.05)) {
                if isScrollingRight {
                    scrollOffset -= 1
                    if -scrollOffset >= offsetLimit {
                        isScrollingRight = false
                    }
                } else {
                    scrollOffset += 1
                    if scrollOffset > 20 {
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
    
    private func calculateTotalHashtagWidth() -> CGFloat {
        var totalWidth: CGFloat = 0
        for hashtag in cell.hashtags {
            let size = ("#" + hashtag as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .semibold)])
            totalWidth += size.width
        }
        return totalWidth
    }
}

fileprivate struct FoodSelectedPopupView: View {
    var model: FoodModel
    @Binding var isPresented: Bool
    @Binding var isFullCover: Bool
    var body: some View {
        loadedView
    }
    
    var loadedView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Group {
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            self.isPresented = false
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 20)
                
                Group {
                    Text(model.name)
                        .font(.system(size: 15, weight: .bold))
                    
                    HStack {
                        Text("📍 \(model.location)")
                            .font(.system(size: 12, weight: .semibold))
                        Spacer()
                        Button {
                            if let url = URL(string: model.placeUrl){
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Text("네이버 리뷰")
                                .foregroundColor(.green.opacity(5.0))
                                .font(.system(size: 13, weight: .regular))
                                .overlay(alignment: .bottom) {
                                    Color.green.opacity(5.0)
                                        .frame(height: 1)
                                }
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(model.hashtags, id: \.self) { hashtag in
                                Text("#\(hashtag)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .padding(5)
                                    .background(Color.yellow.opacity(0.3))
                                    .foregroundColor(.black)
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                
                Button {
                    withAnimation {
                        self.isFullCover = true
                        self.isPresented = false
                    }
                } label: {
                    MapView(model: model, isPopup: true, isCover: false)
                        .cornerRadius(15)
                        .padding(.horizontal, 0)
                        .padding(.bottom, 20)
                }
            }
            .padding(.horizontal, 20)
        }
        .background(.white)
        .cornerRadius(15)
        .padding(.horizontal, 20)
        .frame(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height / 1.8)
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
        FoodHotPlaceView(model: [FoodModel(name: "깍뚝", location: "서울특별시 광진구 동일로", placeUrl: "", hashtags: ["삼겹살", "가브리살", "무한리필"], imageUrl: "", topMessage: "세종대학교 1등 맛집")])
//    FoodSelectedPopupView(model: FoodModel(name: "깍뚝", location: "광진구 동일로", placeUrl: "", hashtags: ["좋아", "좋아", "좋아"]))
}
