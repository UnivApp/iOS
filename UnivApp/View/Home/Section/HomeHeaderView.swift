//
//  HomeCategoryView.swift
//  UnivApp
//
//  Created by 정성윤 on 1/2/25.
//

import SwiftUI

struct HomeHeaderView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @State private var currentIndex: Int = 0
    
    
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("강일여고")
                .foregroundColor(.black)
                .font(.system(size: 20, weight: .bold))
            
            let columns = Array(repeating: GridItem(.flexible()), count: 4)
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(CategoryType.allCases, id: \.self) { category in
                    NavigationLink(destination: category.view) {
                        VStack {
                            Image(systemName: category.imageName)
                                .resizable()
                                .scaledToFit()
                                .tint(.blue.opacity(0.5))
                                .frame(width: 35, height: 35)
                            
                            Text(category.title)
                                .foregroundColor(.gray)
                                .font(.system(size: 10, weight: .semibold))
                        }
                    }
                }
            }
            TabView(selection: $currentIndex) {
                ForEach(viewModel.posterData.indices, id: \.self) { index in
                    //                    NavigationLink(destination: viewModel.posterData[index].view) {
                    //                    }
                    Image(viewModel.posterData[index].imageName)
                        .resizable()
                        .scaledToFill()
                        .tag(index)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 40, height: (UIScreen.main.bounds.width - 40) / 3)
            .tabViewStyle(PageTabViewStyle())
            .onReceive(timer) { _ in
                withAnimation {
                    currentIndex = (currentIndex + 1) % viewModel.posterData.count
                }
            }
            .overlay(alignment: .bottomTrailing) {
                CustomPageControl(currentPage: $currentIndex, numberOfPages: viewModel.posterData.count)
                    .cornerRadius(15)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
            }
            .cornerRadius(15)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
    }
}

#Preview {
    HomeHeaderView()
        .environmentObject(HomeViewModel(container: .init(services: StubServices())))
}
