//
//  PageView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/4/24.
//

import SwiftUI

struct PageView: View {
    @StateObject var viewModel: PlayViewModel
    var body: some View {
        TabView {
            ForEach(viewModel.playStub, id: \.self) { cell in
                if let image = cell.image, let title = cell.title, let address = cell.address, let description = cell.description {
                    HStack(spacing: 20) {
                        PlayViewCell(title: title, address: address, description: description, image: image)
                            .tag(cell.id)
                    }
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .frame(height: 250)
        .padding(.horizontal, 0)
    }
}

#Preview {
    PageView(viewModel: PlayViewModel(container: DIContainer(services: StubServices()), searchText: ""))
}
