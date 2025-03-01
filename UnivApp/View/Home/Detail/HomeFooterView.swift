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
        VStack(alignment: .center, spacing: 20) {
            SeperateView()
                .frame(width: UIScreen.main.bounds.width, height: 20)
            
            
            GADBannerViewController(type: .banner)
                .frame(width: UIScreen.main.bounds.width - 40, height: (UIScreen.main.bounds.width - 40) / 3.2)
            
            
        }
    }
}

