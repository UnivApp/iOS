//
//  ListItemsVIew.swift
//  UnivApp
//
//  Created by 정성윤 on 1/13/25.
//

import SwiftUI

struct ListItemsVIew: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: ListViewModel
    @Binding var universityIdToScroll: Int?
    
    var body: some View {
        ScrollView(.vertical) {
            ScrollViewReader { proxy in
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(viewModel.summaryArray, id: \.universityId) { cell in
                        if let id = cell.universityId, let image = cell.logo, let title = cell.fullName, let heartNum = cell.starNum, let starred = cell.starred {
                            HStack(spacing: 20) {
                                ListViewCell(model: SummaryModel(universityId: id, fullName: title, logo: image, starNum: heartNum, starred: starred), listViewModel: self.viewModel)
                                    .environmentObject(authViewModel)
                            }
                            .tag(cell.universityId)
                        }
                    }
                }
                .task {
                    if universityIdToScroll != nil {
                        withAnimation {
                            proxy.scrollTo(universityIdToScroll, anchor: .center)
                        }
                        universityIdToScroll = nil
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
            }
        }
        .padding(.horizontal, 0)
        .padding(.bottom, 0)
        .refreshable {
            viewModel.send(action: .load)
            self.viewModel.searchText = ""
        }
    }
}
