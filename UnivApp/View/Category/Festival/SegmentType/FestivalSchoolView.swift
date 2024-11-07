//
//  FestivalSchoolView.swift
//  UnivApp
//
//  Created by 정성윤 on 11/7/24.
//

import SwiftUI
import Kingfisher

struct FestivalSchoolView: View {
    @StateObject var viewModel: FestivalViewModel
    @StateObject var listViewModel: ListViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        contentView
    }
    
    @ViewBuilder
    var contentView: some View {
        switch listViewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear {
                    listViewModel.send(action: .load)
                }
        case .loading:
            LoadingView(url: "congratulations", size: [150, 150])
        case .success:
            loadedView
                .refreshable {
                    listViewModel.send(action: .load)
                }
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 30) {
                Image("festival_poster")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.top, -20)
                
                Text("학교 목록")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.leading, 20)
                
                SearchView(isFocused: self._isFocused, searchText: $listViewModel.searchText, color: .white)
                    .environmentObject(self.listViewModel)
                
                ForEach(listViewModel.summaryArray, id: \.self) { item in
                    FestivalViewCell(summaryModel: item)
                        .padding(.horizontal, 0)
                }
            }
            .padding(.top, 20)
        }
    }
}

fileprivate struct FestivalViewCell: View {
    var summaryModel: SummaryModel
    
    var body: some View {
        cell
    }
    
    @ViewBuilder
    var cell: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 20) {
                if let image = summaryModel.logo {
                    KFImage(URL(string: image))
                        .resizable()
                        .scaledToFit()
                        .padding(.leading, 10)
                        .frame(width: 80, height: 80)
                }
                Text(summaryModel.fullName ?? "")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.black)
                Spacer()
                NavigationLink(destination: EmptyView()) {
                    Text("학교 축제 알아보기 >")
                        .foregroundColor(.black.opacity(0.5))
                        .font(.system(size: 12, weight: .semibold))
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
            Divider()
        }
        .padding(.horizontal, 20)
    }
}



#Preview {
    FestivalSchoolView(viewModel: .init(container: .init(services: StubServices())), listViewModel: .init(container: .init(services: StubServices()), searchText: ""))
}
