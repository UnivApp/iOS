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
    
    var object: [Object]
    var PlaceArray: [PlayModel]
    var PlaceData: PlayModel
    
    var body: some View {
        loadedView
    }
    
    var loadedView: some View {
        GeometryReader { proxy in
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 20) {
                    TabView(selection: $currentIndex) {
                        if let images = PlaceData.images {
                            ForEach(images.indices, id: \.self) { index in
                                if let image = images[index] {
                                    KFImage(URL(string: image.imageUrl ?? ""))
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
                        if let numberOfPages = PlaceData.images {
                            CustomPageControl(currentPage: $currentIndex, numberOfPages: numberOfPages.count)
                        }
                    }
                    
                    Group {
                        Text(PlaceData.name)
                            .font(.system(size: 20, weight: .bold))
                        
                        Text("📍 \(PlaceData.location)")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.gray)
                        
                        Divider()
                        
                        Text(PlaceData.description)
                            .font(.system(size: 15, weight: .regular))
                            .lineSpacing(10)
                        
                        Text(PlaceData.tip)
                            .font(.system(size: 15, weight: .bold))
                            .lineSpacing(10)
                    }
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)
                    
                    VStack {
                        SeperateView()
                            .frame(height: 20)
                        
                        HScrollView(title: [Text("이런 "), Text("핫플 "), Text("어때요?")], array: object, pointColor: .orange, size: 100, placeData: PlaceArray)
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
                        Image("whiteback")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                }

            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    PlayDetailView(object: [Object(title: "", image: "")], PlaceArray: [PlayModel(name: "", description: "", tip: "", location: "")], PlaceData: PlayModel(name: "", description: "", tip: "", location: ""))
}
