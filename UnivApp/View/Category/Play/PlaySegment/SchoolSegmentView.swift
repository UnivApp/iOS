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
                    Text("대학생들은 어디서 놀지?\n")
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
                    .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width / 2)
                    .padding(.horizontal, 20)
                
                SeperateView()
                    .frame(height: 20)
                
                Text("학교 목록")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.leading, 20)
                
                SearchView(searchText: $listViewModel.searchText)
                    .environmentObject(self.listViewModel)
                
                ForEach(listViewModel.summaryArray, id: \.self) { item in
                    if let title = item.fullName,
                       let address = item.fullName,
                       let description = item.fullName,
                       let image = item.logo {
                        PlayViewCell(title: title, address: address, description: description, image: image)
                            .padding(.horizontal, 0)
                    }
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
                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .center, spacing: 10) {
                            Text("세종대학교")
                                .font(.system(size: 18, weight: .bold))
                            Text("#어린이대공원\n#롯데월드\n#뚝섬유원지")
                                .font(.system(size: 12, weight: .regular))
                                .lineSpacing(3)
                        }.foregroundColor(.black)
                        
                        
                        Spacer()
                        HStack(spacing: -CGFloat((10 * model.count))) {
                            if let images = model[itemIndex].images {
                                ForEach(images.indices, id: \.self) { imageIndex in
                                    if imageIndex < 4 {
                                        Image(images[imageIndex] ?? "")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(15)
                                    }
                                }
                            }
                        }
                    }
                    Text("대학별 다양한 핫플을 확인해 보세요!")
                        .foregroundColor(.gray)
                        .font(.system(size: 12, weight: .semibold))
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
                .padding(.bottom, 20)
        }
        .padding(.horizontal, 20)
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.homeColor))
    }
}

#Preview {
    SchoolSegmentView(viewModel: PlayViewModel(container: DIContainer(services: StubServices())), listViewModel: ListViewModel(container: DIContainer(services: StubServices()), searchText: ""))
}
