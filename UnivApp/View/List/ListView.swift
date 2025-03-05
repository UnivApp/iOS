//
//  ListViewController.swift
//  UnivApp
//
//  Created by 정성윤 on 3/2/25.
//

import SwiftUI

struct ListView: View {
    @StateObject var viewModel: ListViewModel
    @State var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            loadedView
                .background(.white)
                .navigationTitle("게시판👀")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            PlaceholderView()
        case .loading:
            LoadingView(url: "", size: [150, 150])
        case .success:
            loadedView
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        List {
            VStack(alignment: .center, spacing: 12) {
                ForEach(0...10, id: \.self) { _ in
                    CustomCellView()
                }
            }
        }
        .searchable(text: $searchText, prompt: "검색어를 입력하세요")
        .padding(.top, 12)
        .listStyle(.plain)
    }
}

fileprivate struct CustomCellView: View {

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "pin.fill")
                    .resizable()
                    .tint(.blue.opacity(0.5))
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                VStack(alignment: .leading) {
                    Text("인기🔥 게시판")
                        .font(.headline)
                }
                Spacer()
            }
            Spacer()
        }
        .background(.white)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }
}


//struct list_Preview: PreviewProvider {
//    static var previews: some View {
//
//        ListViewController(viewModel: ListViewModel())
//    }
//}
