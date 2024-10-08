//
//  FoodSchoolDetailView.swift
//  UnivApp
//
//  Created by 정성윤 on 10/8/24.
//

import SwiftUI

struct FoodSchoolDetailView: View {
    @StateObject var viewModel: FoodViewModel
    @Environment(\.dismiss) var dismiss
    var model: SummaryModel
    var body: some View {
        contentView
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image("blackback")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    })
                }
            }
    }
    @ViewBuilder
    var contentView: some View {
        switch self.viewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear {
                    viewModel.send(action: .detailLoad(model.universityId ?? 0))
                }
        case .loading:
            LoadingView(url: "congratulations", size: [150, 150])
        case .success:
            loadedView
                .refreshable {
                    viewModel.send(action: .detailLoad(model.universityId ?? 0))
                }
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        ScrollView(.vertical) {
            VStack(spacing: 20) {
                HStack{
                    Text(model.fullName ?? "")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    Spacer()
                }.padding(.horizontal, 30)
                
                FoodHotPlaceView(model: viewModel.schoolFoodData)
            }
        }
    }
}

#Preview {
    FoodSchoolDetailView(viewModel: FoodViewModel(container: .init(services: StubServices())), model: SummaryModel(universityId: nil, fullName: nil, logo: nil, starNum: nil, starred: nil))
}
