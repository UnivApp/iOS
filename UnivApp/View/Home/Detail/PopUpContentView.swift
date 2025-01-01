//
//  PopUpContentView.swift
//  UnivApp
//
//  Created by 정성윤 on 10/3/24.
//

import SwiftUI
import Kingfisher

struct PopUpContentView: View {
    var summary: [SummaryModel]
    @Binding var isShowingPopup: Bool
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        self.isShowingPopup = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.gray)
                }
                .padding()
            }
            .padding(.bottom, 10)
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                    ForEach(summary, id: \.self) { item in
                        PopUpCell(summaryModel: item)
                            .padding(.horizontal, 0)
                    }
                }
            }
        }
        .frame(maxHeight: UIScreen.main.bounds.height / 1.5)
        .background(.white)
    }
}
fileprivate struct PopUpCell: View {
    var summaryModel: SummaryModel
    @State var isPresented: Bool = false
    @State private var opacity: Bool = false
    
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
                Text(summaryModel.fullName ?? "검색 조건에 맞는 결과가 없습니다 ⚠️")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.black)
                Spacer()
                Button {
                    self.isPresented = true
                } label: {
                    Text("정보 보기 ▷")
                        .foregroundColor(.black.opacity(0.5))
                        .font(.system(size: 12, weight: .semibold))
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                }

            }
            Divider()
        }
        .fullScreenCover(isPresented: $isPresented) {
            ListDetailView(viewModel: ListDetailViewModel(container: .init(services: Services())), universityId: summaryModel.universityId ?? 0)
                .fadeInOut($opacity)
        }
        .transaction { $0.disablesAnimations = true }
        .padding(.horizontal, 20)
    }
}

//struct  {
//    PopUpContentView(summary: [SummaryModel(universityId: nil, fullName: nil, logo: nil, starNum: nil, starred: nil)], isShowingPopup: <#Binding<Bool>#>)
//}
