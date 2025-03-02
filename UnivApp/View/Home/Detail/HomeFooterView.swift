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
            
            Text("급식표")
                .foregroundColor(.black)
                .font(.system(size: 20, weight: .bold))
            
            
            VStack(alignment: .leading, spacing: 8) {
                
            }
        }
    }
}

struct footer_Preview: PreviewProvider {
    static var previews: some View {
        @State var selectedSegment: SplitType = .Occasion
        HomeFooterView(selectedSegment: $selectedSegment)
            .environmentObject(HomeViewModel(container: .init(services: StubServices())))
    }
}
