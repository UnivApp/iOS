//
//  SchoolSegmentView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/24/24.
//

import SwiftUI

struct SchoolSegmentView: View {
    @StateObject var viewModel: PlayViewModel
    @StateObject var listViewModel: ListViewModel
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 30) {
                Group {
                    Text("대학생들은 뭐하고 놀지?\n")
                        .font(.system(size: 25, weight: .bold))
                     + Text("서울 도심 25개 자치구 #핫플레이스")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.gray)
                }
                .padding(.leading, 20)
                .lineSpacing(10)
                
                Image("play_poster")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width)
                
                SchoolToHotplaceCell(model: viewModel.data)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 2)
                
                SeperateView()
                    .frame(height: 20)
                
                Text("학교 목록")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.leading, 20)
                
                SearchView(searchText: $viewModel.searchText)
                    .environmentObject(self.listViewModel)
                
                ForEach(viewModel.playStub, id: \.self) { item in
                    PlayViewCell(title: item.title ?? "", address: item.address ?? "", description: item.description ?? "", image: item.image ?? "")
                        .padding(.horizontal, 0)
                }
            }
            .padding(.top, 20)
        }
    }
}

fileprivate struct SchoolToHotplaceCell: View {
    var model: [PlayDetailModel]
    
    @State var currentIndex: Int = 0
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(model.indices, id: \.self) { itemIndex in
                VStack(alignment: .center) {
                    Text("세종대학교")
                        .font(.system(size: 20, weight: .heavy))
                        .foregroundColor(.gray)
                    
                    HStack(spacing: -CGFloat((5 * model.count))) {
                        if let images = model[itemIndex].images {
                            ForEach(images.indices, id: \.self) { imageIndex in
                                if imageIndex < 4 {
                                    Image(images[imageIndex] ?? "")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(15)
                                }
                            }
                        }
                    }
                }
                .tag(itemIndex)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .onReceive(timer) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % model.count
            }
        }
        .overlay(alignment: .bottomTrailing) {
            CustomPageControl(currentPage: $currentIndex, numberOfPages: model.count)
                .cornerRadius(15)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    SchoolSegmentView(viewModel: PlayViewModel(container: DIContainer(services: StubServices()), searchText: ""), listViewModel: ListViewModel(container: DIContainer(services: StubServices()), searchText: ""))
}
