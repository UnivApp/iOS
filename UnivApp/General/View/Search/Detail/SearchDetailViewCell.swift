//
//  SearchDetailViewCell.swift
//  UnivApp
//
//  Created by 정성윤 on 1/3/25.
//

import SwiftUI
import Kingfisher

struct SearchDetailViewCell: View {
    var summaryModel: SummaryModel
    
    var body: some View {
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
                NavigationLink(destination: ListDetailView(viewModel: ListDetailViewModel(container: .init(services: Services())), universityId: summaryModel.universityId ?? 0)) {
                    Text("▷")
                }
            }
            Divider()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    SearchDetailViewCell(summaryModel: SummaryModel(universityId: nil, fullName: nil, logo: nil, starNum: nil, starred: nil))
}
