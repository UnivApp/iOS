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
    @State private var selectedSegment: String = ""
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
                    viewModel.send(.eventLoad)
                }
        case .loading:
            LoadingView(url: "congratulations", size: [150, 150])
        case .success:
            loadedView
                .onAppear {
                    selectedSegment = "\(viewModel.SchoolFestivalData[0].year)년 \(viewModel.SchoolFestivalData[0].eventName)"
                    viewModel.send(.load(selectedSegment))
                }
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
                                        if self.selectedSegment != "\(viewModel.SchoolFestivalData[index].year)년 \(viewModel.SchoolFestivalData[index].eventName)" {
                                            self.selectedSegment = "\(viewModel.SchoolFestivalData[index].year)년 \(viewModel.SchoolFestivalData[index].eventName)"
                                            self.currentIndex = index
                                            
                                            viewModel.send(.load(selectedSegment))
                                        }
                                    } label: {
                                        Text("\(viewModel.SchoolFestivalData[index].year)년 \(viewModel.SchoolFestivalData[index].eventName)")
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(selectedSegment == "\(viewModel.SchoolFestivalData[index].year)년 \(viewModel.SchoolFestivalData[index].eventName)" ? .black : .gray)
                                            .padding()
                                            .background(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .fill(selectedSegment == "\(viewModel.SchoolFestivalData[index].year)년 \(viewModel.SchoolFestivalData[index].eventName)" ? Color.yellow : Color.backGray)
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
    var model: FestivalYearData
    
    var body: some View {
        Group {
            let flattenedLineup = model.dayLineup.flatMap { daylineup in
                daylineup.lineup.map { lineup in
                    (name: lineup.name, day: daylineup.day, image: lineup.image)
                }
            }
            
            TabView(selection: $currentIndex) {
                ForEach(flattenedLineup.indices, id: \.self) { index in
                    VStack {
                        if let url = URL(string: flattenedLineup[index].image), !flattenedLineup[index].image.isEmpty {
                            KFImage(url)
                                .resizable()
                                .scaledToFill()
                        } else {
                            Color.gray.opacity(0.2)
                                .overlay(alignment: .center) {
                                    if flattenedLineup[index].image == "" {
                                        ProgressView()
                                            .progressViewStyle(.circular)
                                            .tint(.gray)
                                    }
                                }
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(model.eventName) \(flattenedLineup[currentIndex].day)")
                        .font(.system(size: 15, weight: .heavy))
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 15).fill(.orange))
                    Text(flattenedLineup[currentIndex].name)
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
    var model: FestivalYearData
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 5) {
                Text(model.eventName)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(model.date)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 30)
            
            Group {
                Text("\(model.year)년도 ").foregroundColor(.primary) + Text("\(model.eventName) 축제 ").foregroundColor(.orange) + Text("라인업").foregroundColor(.primary)
            }
            .font(.system(size: 15, weight: .bold))
            .padding(.horizontal, 30)
            
            CustomCalendar(model: self.model)
        }
    }
}

fileprivate struct CustomCalendar: View {
    var model: FestivalYearData
    private let week: [String] = ["Day1", "Day2", "Day3", "Day4", "Day5"]
    private let columns = Array(repeating: GridItem(.flexible()), count: 5)
    
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
                
                let flattenedLineup = model.dayLineup.flatMap { daylineup in
                    daylineup.lineup.map { lineup in
                        (name: lineup.name, day: daylineup.day, image: lineup.image)
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
                                    if let url = URL(string: flattenedLineup[index].image), !flattenedLineup[index].image.isEmpty {
                                        VStack(alignment: .center, spacing: 3) {
                                            KFImage(url)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 30, height: 30)
                                                .cornerRadius(15)
                                            Text(flattenedLineup[index].name)
                                                .font(.system(size: 10, weight: .semibold))
                                                .foregroundColor(.primary)
                                                .multilineTextAlignment(.center)
                                        }
                                    } else {
                                        VStack(alignment: .center, spacing: 3) {
                                            Circle()
                                                .fill(.gray.opacity(0.2))
                                                .frame(width: 30, height: 30)
                                                .overlay(alignment: .center) {
                                                    if flattenedLineup[index].image == "" {
                                                        ProgressView()
                                                            .progressViewStyle(.circular)
                                                            .tint(.gray)
                                                    }
                                                }
                                            Text(flattenedLineup[index].name)
                                                .font(.system(size: 10, weight: .semibold))
                                                .foregroundColor(.primary)
                                                .multilineTextAlignment(.center)
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }
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
        .padding(.bottom, 20)
    }
}

#Preview {
    FestivalDetailView(viewModel: FestivalDetailViewModel(container: .init(services: StubServices())))
}