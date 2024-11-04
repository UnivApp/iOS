//
//  FoodView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import SwiftUI
import Kingfisher

struct FoodView: View {
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: FoodViewModel
    @StateObject var listViewModel: ListViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedModel: [FoodModel]? = nil
    @State private var isModal: Bool = true
    @State private var isSearch: Bool = false
    
    var body: some View {
        contentView
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("whiteback")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Image("food_navi")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 60)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.send(action: .load("세종대학교"))
                    } label: {
                        Image("refresh")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                }
            }
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            loadedView
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
                VStack {
                    ZStack {
                        MapView(model: viewModel.FoodData, isCover: false)
                            .ignoresSafeArea()
                        VStack {
                            Spacer()
                            Button  {
                                withAnimation {
                                    self.isModal.toggle()
                                }
                            } label: {
                                Image(isModal ? "arrow_down" : "arrow_up")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                            }
                        }
                        .padding(.bottom, 10)
                    }
                    
                    if isModal {
                        ScrollView(.vertical) {
                            ForEach(viewModel.FoodData.indices, id: \.self) { index in
                                FoodHotPlaceCell(cell: [viewModel.FoodData[index]], isPresented: $isModal, selectedModel: $selectedModel)
                                    .presentationDetents([.height(300), .fraction(0.15)])
                                    .presentationDragIndicator(.visible)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3)
                        .background(RoundedRectangle(cornerRadius: 30).fill(.white))
                    }
                }
                VStack(spacing: 10) {
                    SearchView(searchText: $listViewModel.searchText, color: .clear)
                        .environmentObject(listViewModel)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(listViewModel.summaryArray.indices, id: \.self) { index in
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
    
    @Binding var isPresented: Bool
    @Binding var selectedModel: [FoodModel]?
    
    var body: some View {
        loadedView
    }
    
    var loadedView: some View {
        Button {
            self.selectedModel = cell
            withAnimation {
                self.isPresented = true
            }
        } label: {
            HStack(spacing: 30) {
                MapView(model: cell, isCover: false)
                    .frame(width: 80, height: 80)
                    .cornerRadius(15)
                    .allowsHitTesting(false)
                Spacer()
                VStack(alignment: .leading, spacing: 5) {
                    Text(cell[0].name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(cell[0].addressName)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black.opacity(0.7))
                    
                    Text(cell[0].roadAddressName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    Text(cell[0].phone)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.blue.opacity(0.7))
                }
                .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
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

