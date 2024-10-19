//
//  MoneyDetailView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/5/24.
//

import SwiftUI

struct MoneyDetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: MoneyDetailViewModel
    var model: SummaryModel
    
    var body: some View {
        contentView
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
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
                    }
                }
            }
    }
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear {
                    if let universityId = model.universityId {
                        viewModel.send(action: .addressLoad(universityId, "오피스텔"))
                    }
                }
        case .loading:
            LoadingView(url: "congratulations", size: [150, 150])
        case .success:
            loadedView
                .refreshable {
                    if let universityId = model.universityId {
                        viewModel.send(action: .addressLoad(universityId, "오피스텔"))
                    }
                }
        case .fail:
            ErrorView()
        }
    }
    var loadedView: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 20) {
                    HStack {
                        LoadingView(url: "location", size: [50, 50])
                        Text("\(viewModel.address)")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.black.opacity(0.7))
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    
                    AverageRateView(model: model)
                        .environmentObject(viewModel)
                        .padding(.horizontal, 20)
                    
                    Divider()
                        .padding(.horizontal, 20)
                    
                    ForEach(viewModel.rentData.indices, id: \.self) { index in
                        VStack(spacing: 20) {
                            MoneyDetailCell(index: index+1, model: viewModel.rentData[index])
                            
                            SeperateView()
                                .frame(width: UIScreen.main.bounds.width, height: 10)
                        }
                    }
                }
            }
        }
    }
}

fileprivate struct AverageRateView: View {
    @EnvironmentObject var viewModel: MoneyDetailViewModel
    var model: SummaryModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack {
                let columns = Array(repeating: GridItem(.flexible()), count: 4)
                LazyVGrid(columns: columns) {
                    ForEach(MoneySelectedType.allCases, id: \.self) { type in
                        Button {
                            withAnimation {
                                viewModel.selectedType = type
                                if let universityId = model.universityId {
                                    viewModel.send(action: .addressLoad(universityId, type.title))
                                }
                            }
                        } label: {
                            Text(type.title)
                                .font(.system(size: 13, weight: .heavy))
                                .foregroundColor(viewModel.selectedType == type ? .white : .gray)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 15).fill(viewModel.selectedType == type ? .orange : .backGray))
                        }

                    }
                }
            }
            ZStack {
                VStack(spacing: 10) {
                    Text("\(viewModel.averageRent[0])/\(viewModel.averageRent[1])")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.orange)
                    Text("평균 평수 : \(viewModel.averageRent[2])㎡")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.blue.opacity(0.5))
                    
                    Group {
                        Text("\(model.fullName ?? "") ")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.orange)
                        +
                        Text("월세 평균 호가 🔍")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black.opacity(0.7))
                    }.padding(.horizontal, 10)
                }
                HStack(alignment: .center) {
                    Spacer()
                    LoadingView(url: "coinGif", size: [80,200])
                        .opacity(0.7)
                }
            }
            
            
            HStack {
                Spacer()
                Text("정보제공 : 서울 열린데이터 광장")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.gray)
            }
        }
    }
}

fileprivate struct MoneyDetailCell: View {
    var index: Int
    var model: MoneyModel
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                Text("\(index)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color.white)
                    .padding(5)
                    .background(Circle().fill(.orange))
                    .multilineTextAlignment(.center)
                
                Text("\(model.CGG_NM) \(model.STDG_NM)")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color.black.opacity(0.7))
                
                Text(model.BLDG_NM ?? "")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color.black)
                
                Spacer()
            }
            
            HStack {
                Spacer()
                Text("보증금: \(model.GRFE) / 월세 : \(model.RTFE)")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color.black)
                Text("평형 : \(String(format: "%.2f", model.RENT_AREA))㎡")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.blue.opacity(0.5))
            }
            
            HStack {
                Spacer()
                Text(model.BLDG_USG ?? "")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color.black.opacity(0.7))
                
                Text("계약기간 : \(model.CTRT_PRD ?? "")")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color.black.opacity(0.7))
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    MoneyDetailView(viewModel: MoneyDetailViewModel(container: .init(services: StubServices())), model: .init(universityId: nil, fullName: "세종대학교", logo: nil, starNum: nil, starred: nil))
}
