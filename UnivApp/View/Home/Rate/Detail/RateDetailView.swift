//
//  RateDetailView.swift
//  UnivApp
//
//  Created by 정성윤 on 10/14/24.
//

import SwiftUI
import Kingfisher
import Combine

struct RateDetailView: View {
    @StateObject var viewModel: RateDetailViewModel
    @StateObject var listViewModel: ListViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var selectedSegment: SplitType = .employment
    @State var searchText: String = ""
    @FocusState var isFocused: Bool
    
    var body: some View {
        contentView
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("blackback")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }

                }
            }
    }
    
    @ViewBuilder
    var contentView: some View {
        switch self.listViewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear {
                    listViewModel.send(action: .load)
                }
        case .loading:
            LoadingView(url: "congratulations", size: [150, 150])
        case .success:
            loadedView
                .refreshable {
                    listViewModel.send(action: .load)
                }
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        VStack(spacing: 30) {
            SearchView(isFocused: self._isFocused, searchText: $listViewModel.searchText)
                .environmentObject(self.listViewModel)
            
            VStack {
                HStack(spacing: 10) {
                    ForEach(SplitType.allCases, id: \.self) { item in
                        Button(action: {
                            selectedSegment = item
                        }) {
                            Text(item.title)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(selectedSegment == item ? .black : .gray)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(selectedSegment == item ? Color.yellow : Color.backGray)
                                        .frame(height: 40))
                                .cornerRadius(15)
                        }
                    }
                }
                .padding(.top, -10)
                
                ScrollView(.vertical) {
                    Group {
                        switch selectedSegment {
                        case .employment:
                            RateDetailViewList(selectedType: $selectedSegment)
                                .environmentObject(viewModel)
                                .environmentObject(listViewModel)
                        case .Occasion:
                            RateDetailViewList(selectedType: $selectedSegment)
                                .environmentObject(viewModel)
                                .environmentObject(listViewModel)
                        case .ontime:
                            RateDetailViewList(selectedType: $selectedSegment)
                                .environmentObject(viewModel)
                                .environmentObject(listViewModel)
                        }
                    }
                }
            }
        }
    }
}

fileprivate struct RateDetailViewList: View {
    @EnvironmentObject var viewModel: RateDetailViewModel
    @EnvironmentObject var listViewModel: ListViewModel
    @Binding var selectedType: SplitType
    
    var body: some View {
        ForEach(listViewModel.summaryArray.indices, id: \.self) { index in
            VStack(spacing: 30) {
                RateDetailViewCell(summaryModel: listViewModel.summaryArray[index], selectedType: $selectedType, index: index)
                    .environmentObject(viewModel)
                    .environmentObject(listViewModel)
            }
        }
    }
}

fileprivate struct RateDetailViewCell: View {
    @EnvironmentObject var viewModel: RateDetailViewModel
    @EnvironmentObject var listViewModel: ListViewModel
    var summaryModel: SummaryModel
    
    @Binding var selectedType: SplitType
    var index: Int
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(spacing: 20) {
                if let imageUrl = URL(string: summaryModel.logo ?? "") {
                    Text("\(index + 1)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color.white)
                        .padding(5)
                        .background(Circle().fill(.orange))
                        .multilineTextAlignment(.center)
                    KFImage(imageUrl)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    Text(summaryModel.fullName ?? "")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    Button {
                        toggleRate(for: index)
                    } label: {
                        HStack(spacing: 10) {
                            switch selectedType {
                            case .employment:
                                Text("취업률 확인")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.black)
                            case .ontime:
                                
                                Text("정시 경쟁률 확인")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.black)
                            case .Occasion:
                                Text("수시 경쟁률 확인")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.black)
                            }
                            Image(listViewModel.showRateArray[index] ? "arrow_down" : "arrow_fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10, height: 10)
                        }
                    }
                }
            }
            if listViewModel.showRateArray[index] {
                switch selectedType {
                case .employment:
                    RateDetailCell(employModel: viewModel.employmentData, selectedType: $selectedType)
                        .onAppear {
                            viewModel.send(action: .employLoad(summaryModel.universityId ?? 0))
                        }
                case .ontime:
                    RateDetailCell(competitionModel: viewModel.competitionData, selectedType: $selectedType)
                        .onAppear {
                            viewModel.send(action: .competitionLoad(summaryModel.universityId ?? 0))
                        }
                case .Occasion:
                    RateDetailCell(competitionModel: viewModel.competitionData, selectedType: $selectedType)
                        .onAppear {
                            viewModel.send(action: .competitionLoad(summaryModel.universityId ?? 0))
                        }
                }
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 10)
    }
    
    private func toggleRate(for index: Int) {
        if listViewModel.showRateArray[index] {
            listViewModel.showRateArray[index] = false
        } else {
            for i in 0..<listViewModel.showRateArray.count {
                listViewModel.showRateArray[i] = false
            }
            listViewModel.showRateArray[index] = true
        }
    }

}

fileprivate struct RateDetailCell: View {
    var employModel: EmploymentModel?
    var competitionModel: CompetitionModel?
    @Binding var selectedType: SplitType
    var body: some View {
        HStack(spacing: 30) {
            if let employModel = employModel,
               let rates = employModel.employmentRateResponses {
                ForEach(rates.indices, id: \.self) { index in
                    VStack(spacing: 5) {
                        Text(String(format: "%.1f", rates[index].employmentRate ?? 0))
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color.black)
                        
                        Text("\(rates[index].year ?? "")년")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(Color.gray)
                    }
                    .multilineTextAlignment(.center)
                }
            }
            if let competitionModel = competitionModel,
               let rates = competitionModel.competitionRateResponses {
                if self.selectedType == .Occasion {
                    HStack(spacing: 30) {
                        ForEach(rates.indices, id: \.self) { index in
                            VStack(spacing: 5) {
                                Text(String(format: "%.1f", rates[index].earlyAdmissionRate ?? 0))
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Color.black)
                                
                                Text("\(rates[index].year ?? "")년")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(Color.gray)
                            }
                            .multilineTextAlignment(.center)
                        }
                    }
                } else if self.selectedType == .ontime {
                    HStack(spacing: 30) {
                        ForEach(rates.indices, id: \.self) { index in
                            VStack(spacing: 5) {
                                Text(String(format: "%.1f", rates[index].regularAdmissionRate ?? 0))
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Color.black)
                                
                                Text("\(rates[index].year ?? "")년")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(Color.gray)
                            }
                            .multilineTextAlignment(.center)
                        }
                    }
                }
            }
        }
    }
}
#Preview {
    RateDetailView(viewModel: RateDetailViewModel(container: .init(services: StubServices())), listViewModel: ListViewModel(container: .init(services: StubServices()), searchText: ""))
}
