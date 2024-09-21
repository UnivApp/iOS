//
//  ListDetailView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/5/24.
//

import SwiftUI
import Kingfisher

struct ListDetailView: View {
    @StateObject var viewModel: ListDetailViewModel
    @State private var selectedType: ListDetailType?
    @State private var isNavigate: Bool = false
    @State private var selectedSegment: ListDetailSection = .general
    @Environment(\.dismiss) var dismiss
    
    var universityId: Int
    
    var body: some View {
        contentView
            .navigationTitle("")
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            loadedView
                .onAppear{
                    viewModel.send(action: .load(self.universityId))
                }
        case .loading:
            LoadingView(url: "congratulations")
        case .success:
            loadedView
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        info
                            .padding(.horizontal, 30)
                            .id("기본정보")
                        
                        SeperateView()
                            .frame(height: 10)
                        
                        HStack {
                            Text("기본정보")
                                .font(.system(size: 18, weight: .bold))
                            Spacer()
                        }
                        .padding(.leading, 20)
                        
                        BarChartView(title: "계열별등록금", description: "출처: 대학어디가 - 2024년도" , dataPoints: [
                            ChartData(label: "인문", value: 673, xLabel: "과", yLabel: "만원"),
                            ChartData(label: "자연", value: 796, xLabel: "과", yLabel: "만원"),
                            ChartData(label: "공학", value: 898, xLabel: "과", yLabel: "만원"),
                            ChartData(label: "의학", value: 1000, xLabel: "과", yLabel: "만원"),
                            ChartData(label: "예체", value: 901, xLabel: "과", yLabel: "만원"),
                            ChartData(label: "평균", value: 817, xLabel: "과", yLabel: "만원")
                        ])
                        .padding(.horizontal, 30)
                        
                        CircleChartView(title: "계열별등록금", description: "출처: 대학어디가 - 2024년도", dataPoints: [
                            ChartData(label: "인문사회계열", value: 673, xLabel: "과", yLabel: "만원"),
                            ChartData(label: "자연과학계열", value: 796, xLabel: "과", yLabel: "만원"),
                            ChartData(label: "공학계열", value: 898, xLabel: "과", yLabel: "만원"),
                            ChartData(label: "의학", value: 1000, xLabel: "과", yLabel: "만원"),
                            ChartData(label: "예체계열", value: 901, xLabel: "과", yLabel: "만원")
                        ])
                        .padding(.horizontal, 30)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                BarChartView(title: "정시경쟁률", description: "", dataPoints: [
                                    ChartData(label: "인문", value: 673, xLabel: "과", yLabel: "만원"),
                                    ChartData(label: "자연", value: 796, xLabel: "과", yLabel: "만원")
                                ])
                                BarChartView(title: "정시경쟁률", description: "", dataPoints: [
                                    ChartData(label: "인문", value: 673, xLabel: "과", yLabel: "만원"),
                                    ChartData(label: "자연", value: 796, xLabel: "과", yLabel: "만원")
                                ])
                                BarChartView(title: "정시경쟁률", description: "", dataPoints: [
                                    ChartData(label: "인문", value: 673, xLabel: "과", yLabel: "만원"),
                                    ChartData(label: "자연", value: 796, xLabel: "과", yLabel: "만원")
                                ])
                            }
                        }
                        .padding(.horizontal, 30)
                        
                        SeperateView()
                            .frame(height: 10)
                        
                        depart
                            .padding(.bottom, -20)
                            .id("학과목록")
                        
                        SeperateView()
                            .frame(height: 10)
                        
                        category
                            .padding(.vertical, 0)
                            .padding(.horizontal, 0)
                            .id("카테고리")
                        
                        NavigationLink(destination: selectedType?.view, isActive: $isNavigate) {
                            
                        }
                    }
                }
                .task(id: selectedSegment) {
                    withAnimation(.spring()) {
                        switch selectedSegment {
                        case .general:
                            proxy.scrollTo("기본정보", anchor: .center)
                        case .depart:
                            proxy.scrollTo("학과목록", anchor: .center)
                        case .category:
                            proxy.scrollTo("카테고리", anchor: .center)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("back")
                    }
                    
                }
                ToolbarItem(placement: .navigation) {
                    section
                        .padding()
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    var section: some View {
        VStack {
            HStack(spacing: 10) {
                ForEach(ListDetailSection.allCases, id: \.self) { item in
                    Button(action: {
                        DispatchQueue.main.async {
                            self.selectedSegment = item
                        }
                    }) {
                        Text(item.title)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(selectedSegment == item ? .black : .gray)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(selectedSegment == item ? Color.yellow : Color.clear)
                                    .frame(height: 30))
                            .cornerRadius(15)
                    }
                }
            }.padding(.horizontal, 20)
        }
    }
    
    var info: some View {
        VStack(alignment: .center) {
            HStack(spacing: 10) {
                if let url = URL(string: viewModel.listDetail.logo ?? "") {
                    KFImage(url)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                        .frame(width: 100, height: 100)
                        .padding(.leading, 10)
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text(viewModel.listDetail.fullName ?? "")
                        .font(.system(size: 15, weight: .bold))
                    Spacer()
                    Group {
                        Text("\(viewModel.listDetail.location ?? "")")
                            .font(.system(size: 12, weight: .regular))
                            .frame(height: 12)
                        Text("\(viewModel.listDetail.phoneNumber ?? "")")
                            .font(.system(size: 12, weight: .regular))
                            .frame(height: 12)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 30)
            }
            HStack(spacing: 10) {
                //TODO: - 네비게이션 변경
                NavigationLink(destination: WebKitViewContainer(url: viewModel.listDetail.admissionSite ?? "")) {
                    Text("입학처 열기 🎓")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15)
                    .fill(.orange)
                    .frame(height: 30))
                NavigationLink(destination: WebKitViewContainer(url: viewModel.listDetail.website ?? "")) {
                    Text("홈페이지 열기 🏫")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15)
                    .fill(.orange)
                    .frame(height: 30))
                
            }
            .padding(.trailing, 10)
            .padding(.vertical, 10)
        }
        .frame(height: 200)
    }
    
    var depart: some View {
        VStack(spacing: 0) {
            Group {
                HStack {
                    Text("학과목록")
                        .font(.system(size: 18, weight: .bold))
                    Spacer()
                }
                .padding(.leading, 20)
                
                VStack {
                    ForEach(viewModel.departList, id: \.id) { cell in
                        VStack {
                            HStack {
                                Text(cell.title ?? "")
                                    .foregroundColor(.black)
                                    .font(.system(size: 14, weight: .bold))
                                
                                Spacer()
                                Text(cell.description ?? "")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 12, weight: .regular))
                                    .padding(.trailing, 10)
                                
                                Image("arrow_fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 5, height: 10)
                            }
                            .padding(.bottom, 10)
                            Divider()
                        }
                        .padding(.horizontal, 30)
                    }
                    .padding(.bottom, 20)
                }
                .padding(.top, -20)
            }
            .padding(.vertical, 30)
        }
    }
    
    var category: some View {
        VStack(spacing: 0) {
            HStack {
                Text("카테고리")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
            }
            .padding(.leading, 20)
            .padding(.bottom, 20)
            
            ForEach(ListDetailType.allCases, id: \.self) { type in
                Button {
                    selectedType = type
                    self.isNavigate = true
                } label: {
                    VStack {
                        Text(type.title)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(selectedType == type ? Color.gray : Color.white)
                            .frame(width: 50, height: 50)
                            .background(.clear)
                    }
                    .frame(maxWidth: 70, alignment: .center)
                    
                    HStack {
                        Group {
                            type.image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 35)
                            
                            Text(type.description)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(selectedType == type ? Color.white : Color.gray)
                        }
                        .frame(height: 50)
                        .padding(.leading, 30)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(selectedType == type ? Color.categoryGray : Color.white)
                }
                .background(selectedType == type ? Color.white : Color.categoryGray)
            }
        }
    }
}

struct ListDetailView_PreViews: PreviewProvider {
    static var previews: some View {
        ListDetailView(viewModel: ListDetailViewModel(container: DIContainer(services: StubServices())), universityId: 0)
    }
}
