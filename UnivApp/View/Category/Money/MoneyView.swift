//
//  MoneyView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import SwiftUI
import Charts
import Kingfisher

struct MoneyView: View {
    @StateObject var listViewModel: ListViewModel
    @StateObject var viewModel: MoneyViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocused: Bool
    
    var body: some View {
        contentView
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
    }
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear {
                    viewModel.send(action: .load("", "오피스텔"))
                    listViewModel.send(action: .load)
                }
        case .loading:
            LoadingView(url: "congratulations", size: [150, 150])
        case .success:
            loadedView
                .onTapGesture {
                    self.isFocused = false
                }
                .refreshable {
                    viewModel.send(action: .load("", "오피스텔"))
                    listViewModel.send(action: .load)
                }
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    AverageRateView()
                        .environmentObject(viewModel)
                        .padding(.top, 20)
                    
                    SearchView(isFocused: self._isFocused, searchText: $listViewModel.searchText, color: .white)
                        .environmentObject(self.listViewModel)
                    
                    ForEach(listViewModel.summaryArray, id: \.self) { item in
                        MoneySchoolCell(summaryModel: item)
                            .padding(.horizontal, 0)
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
                        Image("money_navi")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 60)
                    }
                }
            }
        }
    }
}

fileprivate struct AverageRateView: View {
    @EnvironmentObject var viewModel: MoneyViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack {
                let columns = Array(repeating: GridItem(.flexible()), count: 4)
                LazyVGrid(columns: columns) {
                    ForEach(MoneySelectedType.allCases, id: \.self) { type in
                        Button {
                            withAnimation {
                                viewModel.selectedType = type
                                viewModel.send(action: .load("", "\(type.title)"))
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
                    Text("서울 지역 월세 평균 호가 🔍")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black.opacity(0.7))
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
        .padding(.horizontal, 20)
    }
}

fileprivate struct MoneySchoolCell: View {
    var summaryModel: SummaryModel
    
    var body: some View {
        cell
    }
    
    @ViewBuilder
    var cell: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 20) {
                if let image = summaryModel.logo {
                    KFImage(URL(string: image))
                        .resizable()
                        .scaledToFit()
                        .padding(.leading, 10)
                        .frame(width: 80, height: 80)
                }
                Text(summaryModel.fullName ?? "")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.black)
                Spacer()
                NavigationLink(destination: MoneyDetailView(viewModel: MoneyDetailViewModel(container: .init(services: Services())), model: summaryModel)) {
                    Text("주변 월세 알아보기 ▷")
                        .foregroundColor(.black.opacity(0.5))
                        .font(.system(size: 12, weight: .semibold))
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
            Divider()
        }
        .padding(.horizontal, 20)
    }
}

struct MoneyView_Previews: PreviewProvider {
    static var previews: some View {
        MoneyView(listViewModel: ListViewModel(container: .init(services: StubServices()), searchText: ""), viewModel: MoneyViewModel(container: .init(services: StubServices())))
    }
}

