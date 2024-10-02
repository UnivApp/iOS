//
//  PlaySchoolView.swift
//  UnivApp
//
//  Created by 정성윤 on 10/2/24.
//

import SwiftUI
import Kingfisher

struct PlaySchoolView: View {
    @StateObject var viewModel: PlayViewModel
    @State var currentIndex: Int = 0
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var summaryModel: SummaryModel
    
    var body: some View {
        contentView
    }
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear {
                    if let universityId = summaryModel.universityId {
                        viewModel.send(action: .schoolPlaceLoad(universityId))
                    }
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
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 30) {
                Text("\(summaryModel.fullName ?? "")")
                    .font(.system(size: 25, weight: .bold))
                    .padding(.horizontal, 20)
                    .multilineTextAlignment(.leading)
                
                ForEach(viewModel.schoolPlaceData.indices, id: \.self) { index in
                    PlaySchoolCell(model: PlayDetailModel(object: viewModel.convertToObjects(from: viewModel.schoolPlaceData), placeDataArray: viewModel.schoolPlaceData, placeData: viewModel.schoolPlaceData[index]), index: index)
                        .environmentObject(self.viewModel)
                }
            }
        }
        .onDisappear {
            if !viewModel.isNavigatingToDetail {
                viewModel.phase = .notRequested
            } else {
                viewModel.isNavigatingToDetail = false
            }
        }
    }
}

fileprivate struct PlaySchoolCell: View {
    var model: PlayDetailModel
    var index: Int
    
    @EnvironmentObject var viewModel: PlayViewModel
    var body: some View {
        if let placeData = model.placeData {
            NavigationLink(destination: PlayDetailView(playDetailModel: PlayDetailModel(object: model.object, placeDataArray: model.placeDataArray, placeData: model.placeData))) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(placeData.name)
                        .font(.system(size: 15, weight: .bold))
                        .padding(.horizontal, 20)
                    HStack {
                        Spacer()
                        Text("📍 \(placeData.location)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 20)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        if let images = placeData.images {
                            HStack(spacing: 10) {
                                ForEach(images.indices, id: \.self) { index in
                                    if let imageUrl = images[index]?.imageUrl {
                                        KFImage(URL(string: imageUrl))
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(15)
                                            .frame(width: 100, height: 100)
                                    }
                                }
                            }.padding(.horizontal, 20)
                        }
                    }
                }
            }
            .simultaneousGesture(TapGesture().onEnded {
                viewModel.isNavigatingToDetail = true
            })
        }
    }
}
#Preview {
    PlaySchoolView(viewModel: PlayViewModel(container: DIContainer(services: StubServices())), summaryModel: SummaryModel(universityId: nil, fullName: nil, logo: nil, starNum: nil, starred: nil))
}
