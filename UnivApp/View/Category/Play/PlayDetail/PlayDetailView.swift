//
//  PlayDetailView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/5/24.
//

import SwiftUI
import Kingfisher

struct PlayDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var checkScrollHeight: Bool = false
    @State private var currentIndex: Int = 0
    @State private var imageResource: Bool = false
    @State private var imageScreenCover: Bool = false
    @State private var opacity: Double = 0
    
    var playDetailModel: PlayDetailModel
    
    var body: some View {
        loadedView
            .fullScreenCover(isPresented: $imageScreenCover) {
                if let imagesData = playDetailModel.placeData?.images{
                    ImageScreen(images: imagesData.compactMap({ $0?.imageUrl}), isPopup: $imageScreenCover)
                        .presentationBackground(.black.opacity(0.7))
                        .onAppear {
                            withAnimation {
                                opacity = 1
                            }
                        }
                        .onDisappear {
                            withAnimation {
                                opacity = 0
                            }
                        }
                        .opacity(opacity)
                        .animation(.easeInOut(duration: 1.5), value: opacity)
                    
                }
            }
            .transaction { $0.disablesAnimations = true }
    }
    
    var loadedView: some View {
        GeometryReader { proxy in
            ScrollView(.vertical) {
                if let placeData = playDetailModel.placeData {
                    VStack(alignment: .leading, spacing: 20) {
                        TabView(selection: $currentIndex) {
                            if let images = placeData.images {
                                ForEach(images.indices, id: \.self) { index in
                                    if let image = images[index] {
                                        Button {
                                            self.imageScreenCover = true
                                        } label: {
                                            KFImage(URL(string: image.imageUrl ?? ""))
                                                .resizable()
                                                .scaledToFit()
                                                .tag(index)
                                        }
                                    } else {
                                        Image("no_image")
                                            .resizable()
                                            .scaledToFit()
                                            .tag(index)
                                    }
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                        .tabViewStyle(PageTabViewStyle())
                        .overlay(alignment: .bottomTrailing) {
                            if let numberOfPages = playDetailModel.placeData?.images {
                                CustomPageControl(currentPage: $currentIndex, numberOfPages: numberOfPages.count)
                            }
                        }
                        
                        Group {
                            Group {
                                Text(placeData.name)
                                    .font(.system(size: 20, weight: .bold))
                                
                                HStack {
                                    LoadingView(url: "location", size: [50, 50])
                                    Text("\(placeData.location)")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                            }
                            
                            Divider()
                            
                            Group {
                                Text("설명")
                                    .font(.system(size: 17, weight: .bold))
                                
                                HStack {
                                    Image("quotes_left")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                    Spacer()
                                }
                                
                                Text(placeData.description)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.black.opacity(0.7))
                                    .lineSpacing(5)
                                
                                HStack {
                                    Spacer()
                                    Image("quotes_right")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                }
                            }
                            
                            Group {
                                Text("🍯 꿀팁")
                                    .font(.system(size: 17, weight: .bold))
                                
                                Text(placeData.tip)
                                    .foregroundColor(.black.opacity(0.7))
                                    .font(.system(size: 15, weight: .semibold))
                                    .lineSpacing(5)
                            }
                        }
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                        
                        
                        Group {
                            if let images = placeData.images {
                                let nonNilSources = images.compactMap { $0?.source }
                                if !nonNilSources.isEmpty { 
                                    Button {
                                        self.imageResource.toggle()
                                    } label: {
                                        HStack(spacing: 20) {
                                            Text("이미지 출처")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(.orange)
                                            Image(self.imageResource ? "arrow_down" : "arrow_fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 10, height: 10)
                                        }
                                        .frame(width: UIScreen.main.bounds.width / 3)
                                    }
                                    if imageResource {
                                        ForEach(nonNilSources, id: \.self) { source in
                                            Text(source)
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.top, 5)
                                    }
                                }
                            }
                        }
                        
                        GADBannerViewController(type: .banner)
                            .frame(width: UIScreen.main.bounds.width - 40, height: (UIScreen.main.bounds.width - 40) / 3.2)
                            .overlay {
                                RoundedRectangle(cornerRadius: 15).stroke(.backGray)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        
                        VStack {
                            SeperateView()
                                .frame(height: 20)
                            
                            HScrollView(title: [Text("이런 "), Text("핫플 "), Text("어때요?")], pointColor: .orange, size: 100, playDeatilModel: PlayDetailModel(object: playDetailModel.object, placeDataArray: playDetailModel.placeDataArray, placeData: playDetailModel.placeData))
                                .frame(height: 200)
                        }
                        .frame(height: 300)
                    }
                    .padding(.horizontal, 0)
                    .background(
                        GeometryReader { innerProxy in
                            Color.clear
                                .onAppear {
                                    DispatchQueue.main.async {
                                        checkScrollHeight = false
                                    }
                                }
                                .onChange(of: innerProxy.frame(in: .global).minY) { value, error in
                                    if value < 0 {
                                        checkScrollHeight = true
                                    } else {
                                        checkScrollHeight = false
                                    }
                                }
                        }
                    )
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    if self.checkScrollHeight {
                        Image("blackback")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        
                    } else {
                        if playDetailModel.placeData?.images?.compactMap({ $0?.imageUrl }).first == "https://d1irw3ts7iwo2y.cloudfront.net/activity/noimage.png" {
                            Image("blackback")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                        } else {
                            Image("whiteback")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                        }
                    }
                }

            }
        }
        .ignoresSafeArea()
    }
}

fileprivate struct ImageScreen: View {
    var images: [String]
    
    @Binding var isPopup: Bool
    
    @State private var currentIndex: Int = 0
    @GestureState private var magnifyBy = 1.0
    @State private var lastScaleValue: CGFloat = 1.0
    @State private var dragOffset: CGSize = .zero
    @State private var lastDragOffset: CGSize = .zero
    
    var magnification: some Gesture {
        MagnifyGesture()
            .updating($magnifyBy) { value, gestureState, _ in
                gestureState = value.magnification
            }
            .onEnded { value in
                lastScaleValue *= value.magnification
                if lastScaleValue < 1.0 {
                    lastScaleValue = 1.0
                    dragOffset = .zero
                    lastDragOffset = .zero
                }
            }
    }
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                if lastScaleValue * magnifyBy > 1.0 {
                    let newOffset = CGSize(width: lastDragOffset.width + value.translation.width,
                                           height: lastDragOffset.height + value.translation.height)
                    
                    let maxOffsetX = (lastScaleValue - 1) * UIScreen.main.bounds.width / 2
                    let maxOffsetY = (lastScaleValue - 1) * UIScreen.main.bounds.height / 2
                    
                    dragOffset = CGSize(
                        width: min(max(newOffset.width, -maxOffsetX), maxOffsetX),
                        height: min(max(newOffset.height, -maxOffsetY), maxOffsetY)
                    )
                }
            }
            .onEnded { _ in
                lastDragOffset = dragOffset
            }
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $currentIndex) {
                ForEach(images.indices, id: \.self) { index in
                    KFImage(URL(string: images[index]))
                        .resizable()
                        .scaledToFit()
                        .tag(index)
                        .scaleEffect(max(lastScaleValue * magnifyBy, 1.0))
                        .offset(x: dragOffset.width, y: dragOffset.height)
                        .gesture(magnification.simultaneously(with: lastScaleValue > 1.0 ? drag : nil))
                }
                .overlay(alignment: .bottomTrailing) {
                    CustomPageControl(currentPage: $currentIndex, numberOfPages: images.count)
                }
            }
            .padding(.all, 0)
            .tabViewStyle(PageTabViewStyle())
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            self.isPopup = false
                        }
                    } label: {
                        Image("close_white")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                            .padding(.trailing, 20)
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    PlayDetailView(playDetailModel: PlayDetailModel(object: [Object(title: "", image: "")], placeDataArray: [PlayModel(name: "", description: "", tip: "", location: "")], placeData: PlayModel(name: "", description: "설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다", tip: "설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다", location: "")))
}
