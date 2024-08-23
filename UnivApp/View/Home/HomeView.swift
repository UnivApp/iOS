//
//  HomeView.swift
//  UnivApp
//
//  Created by 정성윤 on 8/23/24.
//

import SwiftUI

struct HomeView: View {
    @State var searchText: String
    
    init(searchText: String) {
        self.searchText = searchText
        
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = .gray
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                Spacer()
                
                headerView
                
                Spacer()
                
                categoryView
                
                Spacer()
                
                footerView
            }
        }
        
    }
    
    var headerView: some View {
        VStack(alignment: .center, spacing: 5) {
            HStack {
                Button {
                    //TODO: 검색
                } label: {
                    Image("search")
                }
                .padding()
                
                TextField("대학명/소재지", text: $searchText)
                    .padding()
            }
            .padding(.horizontal, 10)
            .background(Color(.backGray))
            .cornerRadius(15)
            .padding(.horizontal, 30)
            
            //임시 이미지
            TabView {
                ForEach(0..<3) { index in
                    Image("TestAd")
                        .resizable()
                        .scaledToFill()
                        .padding(.horizontal, 30)
                        .frame(height: 150)
                }
            }
            .frame(height: 250)
            .tabViewStyle(PageTabViewStyle())
        }
    }
    
    var categoryView: some View {
        Text("카테고리뷰")
    }
    
    var footerView: some View {
        Text("푸터뷰")
    }
    
}

#Preview {
    HomeView(searchText: "")
}
