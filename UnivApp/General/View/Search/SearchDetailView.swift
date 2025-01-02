//
//  SearchDetailView.swift
//  UnivApp
//
//  Created by 정성윤 on 1/2/25.
//

import SwiftUI

struct SearchDetailView: View {
    @StateObject var listViewModel : ListViewModel
    @FocusState var isFocused: Bool
    @State var searchText: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                Button {
                    listViewModel.send(action: .search)
                    listViewModel.searchText = ""
                    isFocused = false
                } label: {
                    Image("search")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                }
                .padding()
                
                TextField("대학명/소재지를 입력하세요", text: $searchText)
                    .focused($isFocused)
                    .font(.system(size: 15, weight: .regular))
                    .padding()
                    .submitLabel(.search)
                    .onSubmit {
                        listViewModel.send(action: .search)
                        listViewModel.searchText = ""
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

struct SearchDetailViewProvider: PreviewProvider {
    static var previews: some View {
        @StateObject var viewModel: ListViewModel = .init(container: .init(services: StubServices()), searchText: "")
        SearchDetailView(listViewModel: viewModel)
    }
}

