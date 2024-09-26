//
//  SearchView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/25/24.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var listViewModel : ListViewModel
    @FocusState var isFocused: Bool
    @Binding var searchText: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                Button {
                    listViewModel.send(action: .search)
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
            }
            .padding(.horizontal, 10)
            .background(Color.white)
            .border(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .leading, endPoint: .trailing), width: 1)
            .cornerRadius(15)
            .overlay (
                RoundedRectangle(cornerRadius: 15)
                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .leading, endPoint: .trailing), lineWidth: 1.5)
            )
        }
        .padding(.horizontal, 20)
    }
}

struct SearchViewProvider: PreviewProvider {
    static var previews: some View {
        @State var searchText = ""
        SearchView(searchText: $searchText)
            .environmentObject(ListViewModel(container: DIContainer(services: StubServices()), searchText: ""))
    }
}
