//
//  InitiativeView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import SwiftUI

struct InitiativeView: View {
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: InitiativeViewModel
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
                    Image("rank_poster")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.top, 20)
                    
                    Text("카테고리")
                        .padding(.leading, 20)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.category.indices, id: \.self) { index in
                                switch viewModel.category[index].image {
                                case "QS":
                                    categoryViewCell(categoryItem: viewModel.category[index], model: viewModel.QSData)
                                case "The":
                                    categoryViewCell(categoryItem: viewModel.category[index], model: viewModel.TheData)
                                case "ARWU":
                                    categoryViewCell(categoryItem: viewModel.category[index], model: viewModel.ARWUData)
                                case "CWUR":
                                    categoryViewCell(categoryItem: viewModel.category[index], model: viewModel.CWURData)
                                case "USNWR":
                                    categoryViewCell(categoryItem: viewModel.category[index], model: viewModel.USNWRData)
                                case "CWTS":
                                    categoryViewCell(categoryItem: viewModel.category[index], model: viewModel.CWTSData)
                                case "NatureIndex":
                                    categoryViewCell(categoryItem: viewModel.category[index], model: viewModel.NatureIndexData)
                                default:
                                    categoryViewCell(categoryItem: viewModel.category[index], model: viewModel.QSData)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    SeperateView()
                        .frame(width: UIScreen.main.bounds.width, height: 20)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("QS 세계대학평가")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("\(viewModel.QSData.compactMap { $0.year }.first ?? "")년도")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.leading, 0)
                        }
                        Spacer()
                        NavigationLink(destination: InitiativeDetailView(model: viewModel.QSData, title: "QS")) {
                            Text("더보기")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.gray)
                            Image("arrow_fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10, height: 10)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    ForEach(viewModel.QSData.indices, id: \.self) { index in
                        if index < 10 {
                            InitiativeViewCell(model: viewModel.QSData[index])
                                .padding(.vertical, -10)
                        }
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
                        Image("initiative_navi")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 60)
                    }
                }
            }
        }
    }
}

fileprivate struct categoryViewCell: View {
    var categoryItem: Object
    var model: [InitiativeModel]
    
    var body: some View {
        NavigationLink(destination: InitiativeDetailView(model: model, title: categoryItem.title)) {
            VStack(spacing: 10) {
                Image(categoryItem.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.homeColor))
                
                Text(categoryItem.title)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.black)
            }
        }
        .frame(height: 100)
    }
}

struct InitiativeView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices())
    static let authViewModel = AuthViewModel(container: .init(services: StubServices()), authState: .auth)
    static var previews: some View {
        InitiativeView(viewModel: InitiativeViewModel(container: Self.container))
            .environmentObject(Self.authViewModel)
            .environmentObject(Self.container)
    }
}

