//
//  FestivalDetailView.swift
//  UnivApp
//
//  Created by 정성윤 on 11/18/24.
//

import SwiftUI
import Kingfisher

struct FestivalDetailView: View {
    @StateObject var viewModel: FestivalDetailViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedSegment: String = "2024"
    @State private var currentIndex: Int = 0
    
    var body: some View {
        contentView
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("whiteback")
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
            PlaceholderView()
                .onAppear {
                    viewModel.send(.load(selectedSegment))
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
        VStack(alignment: .center, spacing: 20) {
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    VStack(alignment: .center, spacing: 20) {
                        FestivalDescriptionView(model: viewModel.SchoolFestivalData[self.currentIndex])
                            .environmentObject(viewModel)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(viewModel.SchoolFestivalData.indices, id: \.self) { index in
                                    Button {
                                        if self.selectedSegment != viewModel.SchoolFestivalData[index].year {
                                            self.selectedSegment = viewModel.SchoolFestivalData[index].year
                                            self.currentIndex = index
                                            viewModel.send(.load(selectedSegment))
                                        }
                                    } label: {
                                        Text("\(viewModel.SchoolFestivalData[index].year)년도")
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(selectedSegment == viewModel.SchoolFestivalData[index].year ? .black : .gray)
                                            .padding()
                                            .background(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .fill(selectedSegment == viewModel.SchoolFestivalData[index].year ? Color.yellow : Color.backGray)
                                                    .frame(height: 40))
                                            .cornerRadius(15)
                                    }
                                }
                            }
                            .padding(.horizontal, 30)
                        }
                        
                        DetailLineupView(model: viewModel.SchoolFestivalData[self.currentIndex])
                    }
                }
                .ignoresSafeArea()
            }
        }
    }
}

fileprivate struct FestivalDescriptionView: View {
    @EnvironmentObject var viewModel: FestivalDetailViewModel
    @State private var currentIndex: Int = 0
    var model: FestivalDetailModel
    
    var body: some View {
        Group {
            let flattenedLineup = model.lineup.flatMap { lineup in
                lineup.detailLineup.map { detail in
                    (day: lineup.day, detailLineup: detail)
                }
            }
            
            TabView(selection: $currentIndex) {
                ForEach(flattenedLineup.indices, id: \.self) { index in
                    VStack {
                        if let url = URL(string: flattenedLineup[index].detailLineup.image), !flattenedLineup[index].detailLineup.image.isEmpty {
                            KFImage(url)
                                .resizable()
                                .scaledToFill()
                        } else {
                            Color.gray.opacity(0.2)
                                .overlay(alignment: .center) {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .tint(.gray)
                                }
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page)
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(flattenedLineup[currentIndex].day)")
                        .font(.system(size: 15, weight: .heavy))
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 15).fill(.orange))
                    Text(flattenedLineup[currentIndex].detailLineup.name)
                        .font(.system(size: 30, weight: .heavy))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
            .overlay(alignment: .bottomTrailing) {
                CustomPageControl(currentPage: $currentIndex, numberOfPages: flattenedLineup.count)
                    .cornerRadius(15)
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
            }
            .frame(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.width) / 1.4)
        }
        .padding(.horizontal, 0)
    }
}

fileprivate struct DetailLineupView: View {
    var model: FestivalDetailModel
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 5) {
                Text(model.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(model.date)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray)
                
                Text(model.play)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black.opacity(0.7))
            }
            .padding(.horizontal, 30)
            
            Group {
                Text("\(model.year)년도 ").foregroundColor(.primary) + Text("\(model.name) 축제 ").foregroundColor(.orange) + Text("라인업").foregroundColor(.primary)
            }
            .font(.system(size: 15, weight: .bold))
            .padding(.horizontal, 30)
            
            CustomCalendar(model: self.model)
            
            SeperateView()
                .frame(width: UIScreen.main.bounds.width, height: 20)
        }
    }
}

fileprivate struct CustomCalendar: View {
    var model: FestivalDetailModel
    private let week: [String] = ["day1", "day2", "day3", "day4", "day5"]
    private let columns = Array(repeating: GridItem(.flexible()), count: 5)
    private let rowCount: [Int]
    private let maxRowCount: Int
    
    init(model: FestivalDetailModel) {
        self.model = model
        self.rowCount = model.lineup.map { lineup in
            lineup.detailLineup.count
        }
        self.maxRowCount = rowCount.max() ?? 0
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            VStack {
                VStack(alignment: .center, spacing: 5) {
                    Text("\(model.year)년")
                        .font(.system(size: 15, weight: .bold))
                    Text(model.date)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray)
                }
                
                let flattenedLineup = model.lineup.flatMap { lineup in
                    lineup.detailLineup.map { detail in
                        (day: lineup.day, detailLineup: detail)
                    }
                }
                
                LazyVGrid(columns: columns) {
                    ForEach(week.indices, id: \.self) { weekIndex in
                        VStack(alignment: .center, spacing: 10) {
                            Text(week[weekIndex])
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.orange)
                            
                            Divider()
                            ForEach(flattenedLineup.indices, id: \.self) { index in
                                if (flattenedLineup[index].day == week[weekIndex]) {
                                    if let url = URL(string: flattenedLineup[index].detailLineup.image), !flattenedLineup[index].detailLineup.image.isEmpty {
                                        VStack(alignment: .center, spacing: 3) {
                                            KFImage(url)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 30, height: 30)
                                                .cornerRadius(15)
                                            Text(flattenedLineup[index].detailLineup.name)
                                                .font(.system(size: 10, weight: .semibold))
                                                .foregroundColor(.primary)
                                        }
                                    } else {
                                        Circle()
                                            .fill(.gray.opacity(0.2))
                                            .frame(width: 40, height: 40)
                                            .overlay(alignment: .center) {
                                                ProgressView()
                                                    .progressViewStyle(.circular)
                                                    .tint(.gray)
                                            }
                                    }
                                }
                            }
                            Spacer()
                        }
                        .frame(height: CGFloat(maxRowCount * 80))
                    }
                }
                .padding(.horizontal, 10)
            }
            .padding(.vertical, 10)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .background(.white)
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.5), radius: 3, x: 1, y: 1)
        .padding(.horizontal, 30)
    }
}

#Preview {
    FestivalDetailView(viewModel: FestivalDetailViewModel(container: .init(services: StubServices())))
}
