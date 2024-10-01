//
//  InfoView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import SwiftUI

struct InfoView: View {
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: InfoViewModel
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
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
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
}

fileprivate struct NewsCell: View {
    var model: NewsModel
    var body: some View {
        VStack {
            Button {
                //TODO: - URL Open
            } label: {
                VStack(alignment: .leading, spacing: 10) {
                    Text(model.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                    
                    Text(model.extract)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    HStack{
                        Spacer()
                        Text(model.date)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.gray)
                    }
                    Divider()
                }
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices())
    static let authViewModel = AuthViewModel(container: .init(services: StubServices()))
    static var previews: some View {
        InfoView(viewModel: InfoViewModel(container: Self.container))
            .environmentObject(Self.authViewModel)
            .environmentObject(Self.container)
    }
}

