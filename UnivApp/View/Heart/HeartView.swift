//
//  HeartView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/4/24.
//

import SwiftUI

struct HeartView: View {
    @StateObject var viewModel: HeartViewModel
    @EnvironmentObject var continer: DIContainer
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                list
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("logo")
                }
            }
        }
    }
    
    var list: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(viewModel.stub, id: \.self) { cell in
                    if let image = cell.image, let title = cell.title, let heartNum = cell.heartNum {
                        HStack(spacing: 20) {
                            ListViewCell(image: image, title: title, heartNum: heartNum, heart: false, listViewModel: ListViewModel(container: .init(services: StubServices()), searchText: ""))
                                .tag(cell.id)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .padding(.horizontal, 0)
        .padding(.bottom, 0)
        .refreshable {
            
        }
    }
}

struct HeartView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices())
    static let authViewModel = AuthViewModel(container: .init(services: StubServices()))
    static var previews: some View {
        HeartView(viewModel: HeartViewModel(container: self.container))
            .environmentObject(Self.authViewModel)
            .environmentObject(Self.container)
    }
}
