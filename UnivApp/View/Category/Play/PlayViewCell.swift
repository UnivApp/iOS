//
//  PlayViewCell.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import SwiftUI
import Kingfisher

struct PlayViewCell: View {
    @StateObject var playViewModel: PlayViewModel
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
                NavigationLink(destination: PlaySchoolView(viewModel: self.playViewModel, summaryModel: self.summaryModel)) {
                    Text("주변 핫플 알아보기 >")
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

