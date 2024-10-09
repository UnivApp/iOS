//
//  InfoView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import SwiftUI

struct InfoView: View {
    @StateObject var viewModel: InfoViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        contentView
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
    }
    
    @ViewBuilder
    var contentView: some View {
        switch self.viewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear {
                    viewModel.send(action: .load)
                }
        case .loading:
            LoadingView(url: "congratulations", size: [150, 150])
        case .success:
            loadedView
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 30) {
                    Image("news_poster")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.top, 20)
                    
                    Group {
                        Text("\(viewModel.newsData.count)")
                            .font(.system(size: 12, weight: .heavy))
                        +
                        Text("건\t|   날짜순")
                            .font(.system(size: 12, weight: .regular))
                    }
                    .foregroundColor(.black)
                    .padding(.leading, 20)
                    
                    ForEach(viewModel.newsData, id: \.self) { newsItem in
                        NewsCell(model: newsItem)
                            .padding(.horizontal, 20)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 0) {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Image("blackback")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                        })
                        Image("info_navi")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 60)
                    }
                }
            }
        }
    }
}

fileprivate struct NewsCell: View {
    var model: NewsModel
    
    var body: some View {
        VStack {
            Button {
                if let newsLink = model.link,
                   let url = URL(string: newsLink){
                    UIApplication.shared.open(url)
                }
            } label: {
                VStack(alignment: .leading, spacing: 20) {
                    Text(model.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(model.source ?? "")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color.black.opacity(0.7))
                    
                    Text("출처 \(model.link ?? "")")
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(.blue.opacity(0.5))
                    
                    HStack{
                        Text("\(model.admissionYear)년도 대입")
                        Spacer()
                        Text("\(model.publishedDate) 발행")
                    }
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.gray)
                    Divider()
                }
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(viewModel: InfoViewModel(container: .init(services: StubServices())))
    }
}

