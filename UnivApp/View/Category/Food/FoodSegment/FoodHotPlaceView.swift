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
    @State private var selectedModel: [FoodModel]?
    @State private var isFullCover: Bool = false
    @State private var opacity: [Bool] = [false, false]
    
    var body: some View {
        loadedView
            .fullScreenCover(isPresented: $isPresented) {
                if let model = selectedModel {
                    
                }
            }
            .background(isPresented ? .black.opacity(0.3) : .white)
            .fullScreenCover(isPresented: $isFullCover) {
                if let model = selectedModel {
//                    MapView(model: model, isFull: true)
//                        .presentationBackground(.black.opacity(0.3))
//                        .fadeInOut($opacity[1])
                }
            }
            .transaction { $0.disablesAnimations = true }
    }
    
    var loadedView: some View {
        ZStack {
            
        }
    }
}

#Preview {
        FoodHotPlaceView(model: [FoodModel(name: "깍뚝", roadAddressName: "광진구 동일로 459", addressName: "지번 주소", phone: "02-12-123", categoryName: "삼겹살", placeUrl: ""),FoodModel(name: "깍뚝", roadAddressName: "광진구 동일로 459", addressName: "지번 주소", phone: "02-12-123", categoryName: "삼겹살", placeUrl: ""),FoodModel(name: "깍뚝", roadAddressName: "광진구 동일로 459", addressName: "지번 주소", phone: "02-12-123", categoryName: "삼겹살", placeUrl: "")])
}
