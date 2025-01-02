//
//  SearchView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/25/24.
//

import SwiftUI

struct SearchView: View {
    
    var body: some View {
        NavigationLink(destination : SearchDetailView(listViewModel: ListViewModel(container: .init(services: Services()), searchText: .init()))) {
            HStack(spacing: 20) {
                Spacer()
                Image("search")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                Text("대학명/소재지를 입력하세요")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            }
            .padding(.horizontal, 20)
            .background(.white)
            .overlay (
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.orange, lineWidth: 1.5)
            )
        }
        .background(.white)
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
    }
}

struct SearchViewProvider: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
