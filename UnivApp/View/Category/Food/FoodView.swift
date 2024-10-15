//
//  FoodView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import SwiftUI

struct FoodView: View {
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: FoodViewModel
    @Environment(\.dismiss) var dismiss
    
    
    @State private var segmentType: FoodSegmentType = .hotPlace
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
            loadedView
                .onAppear {
                    viewModel.send(action: .topLoad)
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
            VStack(alignment: .center, spacing: 20) {
                HStack(spacing: 0) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image("blackback")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    })
                    Image("food_navi")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 60)
                    Spacer()
                }
                .padding(.horizontal, 10)
                
                HStack(spacing: 10) {
                    ForEach(FoodSegmentType.allCases, id: \.self) { segment in
                        Button {
                            self.segmentType = segment
                        } label: {
                            Text(segment.title)
                                .padding()
                                .foregroundColor(.black)
                                .font(.system(size: 15, weight: .bold))
                                .background(RoundedRectangle(cornerRadius: 15)
                                    .fill(segmentType == segment ? .yellow : .backGray)
                                    .frame(height: 40))
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, -20)
                
                Group {
                    if segmentType == .hotPlace {
                        FoodHotPlaceView(model: viewModel.topFoodData)
                    } else {
                        FoodSchoolView(listViewModel: ListViewModel(container: .init(services: Services()), searchText: ""))
                            .environmentObject(self.viewModel)
                    }
                }
            }
        }
    }
}

struct FoodView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices())
    static let authViewModel = AuthViewModel(container: .init(services: StubServices()), authState: .auth)
    static var previews: some View {
        FoodView(viewModel: FoodViewModel(container: Self.container))
            .environmentObject(Self.authViewModel)
            .environmentObject(Self.container)
    }
}

