//
//  BoardListView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/18/25.
//

import SwiftUI

struct BoardListView: View {
    @StateObject var viewModel: BoardListViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    BoardListView(viewModel: BoardListViewModel())
}
