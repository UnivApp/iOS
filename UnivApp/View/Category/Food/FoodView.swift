//
//  FoodView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import SwiftUI
import Kingfisher

enum FoodModalType {
    case close
    case half
    case full
}

struct FoodView: View {
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: FoodViewModel
    @StateObject var listViewModel: ListViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var isModal: FoodModalType = .half
    @State private var isSearch: Bool = false
    
    var body: some View {
        contentView
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .toolbar(.hidden, for: .navigationBar)
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear {
                    viewModel.send(action: .load("세종대학교"))
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
            ZStack {
                VStack(spacing: 0) {
                    ZStack {
                        MapView(model: viewModel.FoodData)
                            .environmentObject(viewModel)
                            .ignoresSafeArea()
                        VStack {
                            Spacer()
                            HStack(spacing: 10) {
                                Spacer()
                                Button  {
                                    withAnimation {
                                        switch isModal {
                                        case .close:
                                            isModal = .half
                                        case .half:
                                            isModal = .full
                                        case .full:
                                            isModal = .full
                                        }
                                    }
                                } label: {
                                    Image("arrow_up")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 10, height: 10)
                                        .padding(10)
                                        .background(Circle().fill(.yellow))
                                }
                                Button  {
                                    withAnimation {
                                        switch isModal {
                                        case .close:
                                            isModal = .close
                                        case .half:
                                            isModal = .close
                                        case .full:
                                            isModal = .half
                                        }
                                    }
                                } label: {
                                    Image("arrow_down")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 10, height: 10)
                                        .padding(10)
                                        .background(Circle().fill(.yellow))
                                }
                            }
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 10)
                    }
                    
                    if (isModal != .close) {
                        ScrollViewReader { proxy in
                            ScrollView(.vertical) {
                                ForEach(viewModel.FoodData.indices, id: \.self) { index in
                                    VStack(spacing: 5) {
                                        FoodHotPlaceCell(cell: [viewModel.FoodData[index]], index: index)
                                        SeperateView()
                                            .frame(width: UIScreen.main.bounds.width, height: 10)
                                    }
                                    .id(index)
                                    .padding(.top, 5)
                                }
                            }
                            .onChange(of: viewModel.FoodData) {
                                proxy.scrollTo(0, anchor: .top)
                            }
                            .frame(width: UIScreen.main.bounds.width, height: (isModal == .full) ? UIScreen.main.bounds.height / 1.5 :  UIScreen.main.bounds.height / 3)
                        }
                    }
                }
                VStack(spacing: 5) {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image("blackback")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            Image("food_navi")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 60)
                        }
                        Spacer()
                        Button {
                            viewModel.send(action: .load("세종대학교"))
                            listViewModel.summaryArray = []
                        } label: {
                            Image("refresh")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                        }
                    }
                    .padding(.horizontal, 20)
                    
//                    SearchView(searchText: $listViewModel.searchText, color: .clear)
//                        .environmentObject(listViewModel)
//                        .onTapGesture {
//                            isModal = .half
//                        }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(listViewModel.summaryArray.indices, id: \.self) { index in
                                Button  {
                                    viewModel.send(action: .load(listViewModel.summaryArray[index].fullName ?? ""))
                                    listViewModel.summaryArray = []
                                } label: {
                                    VStack(spacing: 5) {
                                        if let url = listViewModel.summaryArray[index].logo,
                                           let imageURL = URL(string: url),
                                           let name = listViewModel.summaryArray[index].fullName{
                                            KFImage(imageURL)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 30, height: 30)
                                            Text(name)
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                                .frame(width: 80, height: 100)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 15).fill(.white))
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    Spacer()
                }
            }
        }
    }
}

fileprivate struct FoodHotPlaceCell: View {
    var cell: [FoodModel]
    var index: Int
    
    @State private var isPresented: Bool = false
    @State private var opacity: Bool = false
    
    var body: some View {
        loadedView
            .fullScreenCover(isPresented: $isPresented) {
                FoodSelectedPopupView(model: cell, isPresented: $isPresented)
                    .presentationBackground(.black.opacity(0.7))
                    .fadeInOut($opacity)
            }
            .transaction { $0.disablesAnimations = true}
    }
    var loadedView: some View {
        Button {
            withAnimation {
                self.isPresented = true
            }
        } label: {
            VStack {
                HStack {
                    Text("# \(cell[0].categoryName)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black.opacity(0.7))
                    Spacer()
                }
                HStack(spacing: 20) {
                    Text("\(index+1)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color.white)
                        .padding(5)
                        .background(Circle().fill(.orange))
                        .multilineTextAlignment(.center)
                    
                    MapView(model: cell)
                        .frame(width: 80, height: 80)
                        .cornerRadius(15)
                        .allowsHitTesting(false)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(cell[0].name)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.black.opacity(0.7))
                        
                        Text(cell[0].addressName)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.black.opacity(0.7))
                        
                        Text(cell[0].roadAddressName)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.gray)
                        
                        Text(cell[0].phone)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.blue.opacity(0.7))
                    }
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 10)
                    Spacer()
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 5)
        }
    }
}

struct FoodView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices())
    static let authViewModel = AuthViewModel(container: .init(services: StubServices()), authState: .auth)
    static var previews: some View {
        FoodView(viewModel: FoodViewModel(container: Self.container), listViewModel: ListViewModel(container: container, searchText: ""))
            .environmentObject(Self.authViewModel)
            .environmentObject(Self.container)
    }
}

