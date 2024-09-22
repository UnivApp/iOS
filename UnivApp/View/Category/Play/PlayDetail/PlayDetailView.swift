//
//  PlayDetailView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/5/24.
//

import SwiftUI

struct PlayDetailView: View {
    @StateObject var viewModel: PlayDetailViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        contentView
    }
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            loadedView //TODO: - 변경
        case .loading:
            LoadingView(url: "congratulations")
        case .success:
            loadedView
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ZStack {
                        TabView {
                            if let images = viewModel.data.images {
                                ForEach(images, id: \.self) { item in
                                    if let image = item {
                                        Image(image)
                                            .resizable()
                                            .scaledToFit()
                                    }
                                }
                            }
                        }
                        .frame(width: proxy.size.width, height: proxy.size.width)
                        .tabViewStyle(PageTabViewStyle())
                        
                        VStack {
                            HStack {
                                Button {
                                    dismiss()
                                } label: {
                                    CustomNavigationBar()
                                }
                                Spacer()
                            }
                            Spacer()
                        }
                        .padding(.top, 30)
                        .padding(.leading, 0)
                    }
                    
                    Group {
                        Text(viewModel.data.title ?? "")
                            .font(.system(size: 20, weight: .bold))
                        
                        Text("📍 \(viewModel.data.location ?? "")")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.gray)
                        
                        Divider()
                        
                        Text(viewModel.data.description ?? "")
                            .font(.system(size: 15, weight: .regular))
                        
                        Text(viewModel.data.tip ?? "")
                            .font(.system(size: 15, weight: .bold))
                    }
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)
                    
                    VStack {
                        SeperateView()
                            .frame(height: 20)
                        
                        HScrollView(title: [Text("이런 "), Text("핫플 "), Text("어때?")], array: [Object(title: "어린이대공원", image: "hotplace1"),Object(title: "롯데월드", image: "hotplace2"),Object(title: "올림픽공원", image: "hotplace3"),Object(title: "서울숲", image: "hotplace4"),Object(title: "어린이대공원", image: "hotplace1"),Object(title: "롯데월드", image: "hotplace2")], pointColor: .orange)
                            .padding(.leading, -20)
                            .frame(height: 200)
                    }
                    .frame(height: 300)
                }
                .padding(.horizontal, 0)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea()
    }
}

#Preview {
    PlayDetailView(viewModel: PlayDetailViewModel())
}
