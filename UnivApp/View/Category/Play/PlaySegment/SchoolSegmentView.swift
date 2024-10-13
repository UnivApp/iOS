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
    @FocusState private var isFocused: Bool
    
    var body: some View {
        contentView
    }
    
    @ViewBuilder
    var contentView: some View {
        switch listViewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear {
                    listViewModel.send(action: .load)
                }
        case .loading:
            LoadingView(url: "congratulations", size: [150, 150])
        case .success:
            loadedView
                .refreshable {
                    listViewModel.send(action: .load)
                }
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 30) {
                Image("play_poster")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.top, -20)
                
                Text("학교 목록")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.leading, 20)
                
                SearchView(isFocused: self._isFocused, searchText: $listViewModel.searchText)
                    .environmentObject(self.listViewModel)
                
                ForEach(listViewModel.summaryArray, id: \.self) { item in
                    PlayViewCell(playViewModel: self.viewModel, summaryModel: item)
                        .padding(.horizontal, 0)
                }
            }
            .padding(.top, 20)
        }
    }
}

#Preview {
    SchoolSegmentView(viewModel: PlayViewModel(container: DIContainer(services: StubServices())), listViewModel: ListViewModel(container: DIContainer(services: StubServices()), searchText: ""))
}
