//
//  HotPlaceSegmentView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/24/24.
//

import SwiftUI

struct HotPlaceSegmentView: View {
    @StateObject var viewModel: PlayViewModel
    
    @State private var currentIndex: Int = 0
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center, spacing: 30) {
                TabView(selection: $currentIndex) {
                    ForEach(viewModel.hotplaceData.indices, id: \.self) { index in
                        representativePlaceCell(model: viewModel.hotplaceData[index])
                            .tag(index)
                    }
                }
                .overlay(alignment: .bottomTrailing) {
                    CustomPageControl(currentPage: $currentIndex, numberOfPages: viewModel.hotplaceData.count)
                        .cornerRadius(15)
                }
                .padding(.horizontal, 20)
                .frame(height: UIScreen.main.bounds.width * 0.7)
                .tabViewStyle(PageTabViewStyle())
                .onReceive(timer) { _ in
                    withAnimation {
                        currentIndex = (currentIndex + 1) % viewModel.hotplaceData.count
                    }
                }
                
                VStack(spacing: 20) {
                    ForEach(viewModel.hotplaceData.indices, id: \.self) { index in
                        HotPlaceViewCell(model: viewModel.hotplaceData[index], index: index)
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
}

fileprivate struct representativePlaceCell: View {
    var model: PlayModel
    var body: some View {
        ZStack(alignment: .bottomLeading){
            Image(model.image ?? "")
                .resizable()
                .scaledToFill()
                .frame(height: UIScreen.main.bounds.width * 0.7)
                .cornerRadius(15)
                .opacity(0.7)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("\(model.title ?? "")")
                    .font(.system(size: 30, weight: .heavy))
                
                Text("📍 \(model.address ?? "")")
                    .font(.system(size: 18, weight: .heavy))
            }
            .foregroundColor(.white)
            .lineLimit(1)
            .padding(.bottom, 30)
            .padding(.leading, 30)
        }
    }
}

fileprivate struct HotPlaceViewCell: View {
    var model: PlayModel
    var index: Int
    var body: some View {
        HStack(spacing: 30) {
            Image(model.image ?? "")
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
            
            VStack(alignment: .leading, spacing: 5) {
                Text(model.title ?? "")
                    .font(.system(size: 15, weight: .bold))
                Text(model.description ?? "")
                    .font(.system(size: 12, weight: .regular))
                HStack {
                    Spacer()
                    Text("📍 \(model.address ?? "")")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.gray)
                }
            }
        }.padding(.horizontal, 20)
    }
}

#Preview {
    HotPlaceSegmentView(viewModel: PlayViewModel(container: DIContainer(services: StubServices()), searchText: ""))
}
