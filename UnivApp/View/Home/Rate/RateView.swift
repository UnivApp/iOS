//
//  RateView.swift
//  UnivApp
//
//  Created by 정성윤 on 10/14/24.
//

import SwiftUI
import Kingfisher

struct RateView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @StateObject var rateViewModel: RateViewModel
    @Binding var selectedSegment: SplitType
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Group {
                    Text("취업 ")
                        .foregroundColor(.red.opacity(0.7))
                    +
                    Text("경쟁 ")
                        .foregroundColor(.orange)
                    +
                    Text("률")
                        .foregroundColor(.black)
                }
                .font(.system(size: 18, weight: .bold))
                
                Spacer()
                
                NavigationLink(destination: RateDetailView(viewModel: RateDetailViewModel(container: .init(services: Services())), listViewModel: ListViewModel(container: .init(services: Services()), searchText: ""))) {
                    HStack(spacing: 5) {
                        Text("더보기")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.gray)
                        
                        Image("arrow")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                    }
                }
            }
            
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
                .padding()
                
                Group {
                    switch selectedSegment {
                    case .employment:
                        RateList(selectedType: $selectedSegment)
                            .environmentObject(self.rateViewModel)
                    case .Occasion:
                        RateList(selectedType: $selectedSegment)
                            .environmentObject(self.rateViewModel)
                    case .ontime:
                        RateList(selectedType: $selectedSegment)
                            .environmentObject(self.rateViewModel)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.horizontal, 20)
    }
}


fileprivate struct RateList: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @Binding var selectedType: SplitType
    var body: some View {
        switch selectedType {
        case .employment:
            ForEach(viewModel.employmentData.indices, id: \.self) { index in
                if index < 5 {
                    RateCell(employModel: viewModel.employmentData[index], selectedType: $selectedType)
                }
            }
        case .ontime:
            ForEach(viewModel.competitionData.indices, id: \.self) { index in
                if index < 5 {
                    RateCell(competitionModel: viewModel.competitionData[index], selectedType: $selectedType)
                }
            }
        case .Occasion:
            ForEach(viewModel.competitionData.indices, id: \.self) { index in
                if index < 5 {
                    RateCell(competitionModel: viewModel.competitionData[index], selectedType: $selectedType)
                }
            }
        }
    }
}

fileprivate struct RateCell: View {
    var employModel: EmploymentModel?
    var competitionModel: CompetitionModel?
    @Binding var selectedType: SplitType
    
    var body: some View {
        HStack {
            if let employModel = employModel,
               let imageUrl = URL(string: employModel.logo ?? ""),
               let rates = employModel.employmentRateResponses {
                VStack(spacing: 5) {
                    KFImage(imageUrl)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    
                    Text(employModel.name ?? "")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.black.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .frame(width: 60)
                Spacer()
                HStack(spacing: 30) {
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
            }
            
            if let competitionModel = competitionModel,
               let imageUrl = URL(string: competitionModel.logo ?? ""),
               let rates = competitionModel.competitionRateResponses {
                VStack(spacing: 5) {
                    KFImage(imageUrl)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    
                    Text(competitionModel.name ?? "")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                }
                .frame(width: 60)
                Spacer()
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
        .padding(.horizontal, 10)
    }
}

struct RateView_Previews: PreviewProvider {
    static var previews: some View {
        @State var selectedSegment: SplitType = .Occasion
        RateView(rateViewModel: RateViewModel(container: .init(services: Services())), selectedSegment: $selectedSegment)
            .environmentObject(HomeViewModel(container: .init(services: StubServices())))
    }
}
