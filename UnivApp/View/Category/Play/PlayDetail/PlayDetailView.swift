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
    
    var playDetailModel: PlayDetailModel
    
    var body: some View {
        loadedView
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
                                        KFImage(URL(string: image.imageUrl ?? ""))
                                            .resizable()
                                            .scaledToFit()
                                            .tag(index)
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
                                
                                Text("📍 \(placeData.location)")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.gray)
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
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.black)
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
                                    .foregroundColor(.black)
                                    .font(.system(size: 15, weight: .regular))
                                    .lineSpacing(5)
                            }
                        }
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                        
                        
                        Group {
                            
                            if let images = placeData.images {
                                ForEach(images.indices, id: \.self) { index in
                                    if let source = images[index]?.source {
                                        if index < 1 {
                                            Text("이미지 출처\n\n")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(.gray)
                                            +
                                            Text(source)
                                                .font(.system(size: 8, weight: .regular))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                            }
                        }
                        
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

#Preview {
    PlayDetailView(playDetailModel: PlayDetailModel(object: [Object(title: "", image: "")], placeDataArray: [PlayModel(name: "", description: "", tip: "", location: "")], placeData: PlayModel(name: "", description: "설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다", tip: "설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다설명입니다", location: "")))
}
