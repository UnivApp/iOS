//
//  ListDetailView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/5/24.
//

import SwiftUI
import Kingfisher

struct ListDetailView: View {
    @StateObject var viewModel: ListDetailViewModel
    @State private var selectedType: ListDetailType?
    @State private var isNavigate: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var universityId: Int
    
    var body: some View {
        contentView
            .navigationTitle("")
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear{
                    viewModel.send(action: .load(self.universityId))
                }
        case .loading:
            LoadingView(url: "congratulations")
        case .success:
            loadedView
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        NavigationStack {
            VStack {
                info
                    .padding(.vertical, 30)
                    .padding(.horizontal, 30)
                
                category
                    .padding(.vertical, 0)
                    .padding(.horizontal, 0)
                
                NavigationLink(destination: selectedType?.view, isActive: $isNavigate) {
                    
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("back")
                    }

                }
            }
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    var info: some View {
        HStack(spacing: 10) {
            NavigationLink(destination: WebKitViewContainer(url: viewModel.listDetail.website ?? "")) {
                if let url = URL(string: viewModel.listDetail.logo ?? "") {
                    KFImage(url)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                        .frame(width: 100, height: 100)
                        .padding(.leading, 10)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(viewModel.listDetail.fullName ?? "")
                        .font(.system(size: 15, weight: .bold))
                    
                    Group {
                        Text("\(viewModel.listDetail.location ?? "")")
                        Text("\(viewModel.listDetail.phoneNumber ?? "")")
                        HStack {
                            Spacer()
                            Text("웹사이트로 연결 👆🏻")
                                .foregroundColor(.pointColor)
                        }
                        .padding(.trailing, 10)
                    }
                    .font(.system(size: 12, weight: .regular))
                    .frame(height: 12)
                }
                .padding(.horizontal, 10)
            }
        }
        .frame(height: 150)
        .background(.white)
        .cornerRadius(15)
        .shadow(radius: 10)
    }
    
    var category: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                ForEach(ListDetailType.allCases, id: \.self) { type in
                    Button {
                        selectedType = type
                        self.isNavigate = true
                    } label: {
                        VStack {
                            Text(type.title)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(selectedType == type ? Color.gray : Color.white)
                                .frame(width: 50, height: proxy.size.height / 8)
                                .background(.clear)
                        }
                        .frame(maxWidth: 70, alignment: .center)
                        
                        HStack {
                            Group {
                                type.image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: proxy.size.height / 12, height: proxy.size.height / 12)
                                
                                Text(type.description)
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(selectedType == type ? Color.white : Color.gray)
                            }
                            .frame(height: proxy.size.height / 8)
                            .padding(.leading, 30)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(selectedType == type ? Color.categoryGray : Color.white)
                    }
                    .background(selectedType == type ? Color.white : Color.categoryGray)
                }
            }
        }
    }
}

struct ListDetailView_PreViews: PreviewProvider {
    static var previews: some View {
        ListDetailView(viewModel: ListDetailViewModel(container: DIContainer(services: StubServices())), universityId: 0)
    }
}
