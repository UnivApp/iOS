//
//  HomeFooterView.swift
//  UnivApp
//
//  Created by 정성윤 on 1/2/25.
//

import SwiftUI

struct HomeFooterView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @Binding var selectedSegment: SplitType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            GADBannerViewController(type: .banner)
                .frame(width: UIScreen.main.bounds.width - 40, height: (UIScreen.main.bounds.width - 40) / 3.2)
                .padding(.top, 24)
            
            Group {
                HStack {
                    Text("인기🔥 게시판")
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 20, weight: .bold))
                    
                    Spacer()
                    
                    Button {
                        //TODO: 더보기
                    } label: {
                        Text("더보기 ▶︎")
                            .foregroundColor(.gray)
                            .font(.system(size: 15, weight: .semibold))
                    }
                }
                
                ForEach(0...2, id: \.self) { _ in
                    VStack(spacing: 12) {
                        BoardSectionView()
                    }
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 12)
    }
}

struct footer_Preview: PreviewProvider {
    static var previews: some View {
        @State var selectedSegment: SplitType = .Occasion
        HomeFooterView(selectedSegment: $selectedSegment)
            .environmentObject(HomeViewModel(container: .init(services: StubServices())))
    }
}
