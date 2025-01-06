//
//  SearchRecentView.swift
//  UnivApp
//
//  Created by 정성윤 on 1/3/25.
//

import SwiftUI

struct SearchRecentView: View {
    @EnvironmentObject var viewModel: ListViewModel
    @Binding var recentTexts: [String]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(recentTexts, id: \.self) { text in
                    RecentTextCell(text: text)
                        .environmentObject(viewModel)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

fileprivate struct RecentTextCell: View {
    @EnvironmentObject var viewModel: ListViewModel
    var text: String
    var body: some View {
        Button {
            viewModel.searchText = text
            viewModel.send(action: .search)
        } label: {
            Text(text)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)
                .padding(10)
                .background(.backGray)
                .clipped()
                .cornerRadius(15)
        }
    }
}

struct SearchRecentView_Preview: PreviewProvider {
    static var previews: some View {
        @State var texts: [String] = ["세종", "건국", "숭실", "서울대"]
        SearchRecentView(recentTexts: $texts)
            .environmentObject(ListViewModel(container: .init(services: StubServices()), searchText: ""))
    }
}
