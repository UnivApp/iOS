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
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 30) {
                HScrollView(title: [Text("이 학교 "), Text("핫플"), Text("은 뭐가 있을까?")], array: [Object(title: "세종대학교", image: "emptyLogo"), Object(title: "세종대학교", image: "emptyLogo"), Object(title: "세종대학교", image: "emptyLogo"), Object(title: "세종대학교", image: "emptyLogo"), Object(title: "세종대학교", image: "emptyLogo")], pointColor: .pink, size: 60)
                
                SeperateView()
                    .frame(height: 20)
                
                Text("학교 목록")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.leading, 20)
                
                SearchView(searchText: $viewModel.searchText)
                    .environmentObject(self.listViewModel)
                
                ForEach(viewModel.playStub, id: \.self) { item in
                    PlayViewCell(title: item.title ?? "", address: item.address ?? "", description: item.description ?? "", image: item.image ?? "")
                        .padding(.horizontal, 0)
                }
            }
            .padding(.top, 20)
        }
    }
}

#Preview {
    SchoolSegmentView(viewModel: PlayViewModel(container: DIContainer(services: StubServices()), searchText: ""), listViewModel: ListViewModel(container: DIContainer(services: StubServices()), searchText: ""))
}
