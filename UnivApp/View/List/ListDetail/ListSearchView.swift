//
//  ListSearchView.swift
//  UnivApp
//
//  Created by 정성윤 on 1/9/25.
//

import SwiftUI

struct ListSearchView: View {
    @EnvironmentObject var listViewModel : ListViewModel
    @FocusState var isFocused: Bool
    
    var body: some View {
        loadedView
    }
    
    @ViewBuilder
    var loadedView: some View {
        VStack(spacing: 10) {
            searchView
            
            SearchRecentView(recentTexts: $listViewModel.recentTexts)
                .environmentObject(listViewModel)
            
        }
    }
    
    var searchView: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                Button {
                    listViewModel.send(action: .search)
                    isFocused = false
                } label: {
                    Image("search")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 15)
                }
                .padding()
                
                TextField("대학명/소재지를 입력하세요", text: $listViewModel.searchText)
                    .focused($isFocused)
                    .font(.system(size: 15, weight: .regular))
                    .padding()
                    .submitLabel(.search)
                    .onSubmit {
                        listViewModel.send(action: .search)
                        isFocused = false
                    }
            }
            .padding(.horizontal, 10)
            .background(.white)
            .overlay (
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.orange, lineWidth: 1.5)
            )
        }
        .background(.white)
        .padding(.horizontal, 20)
    }
}

#Preview {
    ListSearchView()
}
