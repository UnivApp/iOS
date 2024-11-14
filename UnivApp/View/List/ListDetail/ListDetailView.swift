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
    @State private var selectedSegment: ListDetailSection = .general
    @State private var expandedDepartIds: Set<Int> = []
    @Environment(\.dismiss) var dismiss
    
    var universityId: Int
    
    var body: some View {
        contentView
            .navigationTitle("")
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
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
            LoadingView(url: "congratulations", size: [150, 150])
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
                            .padding(.top, 30)
                            .id("기본정보")
                        
                        SeperateView()
                            .frame(height: 10)
                        
                        HStack {
                            Text("기본정보")
                                .font(.system(size: 18, weight: .bold))
                            Spacer()
                        }
                        .padding(.leading, 20)
                        
                        BarChartView(title: "계열별등록금", description: "출처: 대학어디가 - 2024년도" , dataPoints: viewModel.tuitionFeeData)
                        .padding(.horizontal, 30)
                        
                        CircleChartView(title: "학과 정보", description: "대학어디가 - 정보제공", dataPoints: viewModel.departmentData)
                            .padding(.horizontal, 30)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(viewModel.competitionRateData.indices, id: \.self) { index in
                                    BarChartView(title: "경쟁률", description: "대학어디가 - 정보제공", dataPoints: viewModel.competitionRateData[index])
                                }
                            }
                            .padding(.horizontal, 30)
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(viewModel.employmentRateData.indices, id: \.self) { index in
                                    BarChartView(title: "취업률", description: "대학어디가 - 정보제공", dataPoints: viewModel.employmentRateData[index])
                                }
                            }
                            .padding(.horizontal, 30)
                        }
                        
                        SeperateView()
                            .frame(height: 10)
                        
                        depart
                            .padding(.bottom, -20)
                            .id("학과목록")
                        
                        SeperateView()
                            .frame(height: 10)
                        
                        ListCategoryView(universityID: self.universityId)
                            .padding(.vertical, 0)
                            .padding(.horizontal, 0)
                            .id("카테고리")
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
                        Image("blackback")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                }
                ToolbarItem(placement: .navigation) {
                    section
                        .padding()
                }
            }
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
                        Text("\(viewModel.listDetail.type ?? "")대학교\n\n")
                            .font(.system(size: 12, weight: .semibold))
                                  +
                        Text("\(viewModel.listDetail.location ?? "")\n\(viewModel.listDetail.phoneNumber ?? "")")
                            .font(.system(size: 12, weight: .regular))
                    }
                }
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 10)
                .padding(.vertical, 30)
            }
            HStack(spacing: 10) {
                if let addmissionSite = viewModel.listDetail.admissionSite,
                   let website = viewModel.listDetail.website,
                   let addmissionSiteURL = URL(string: addmissionSite),
                   let websiteURL = URL(string: website){
                    Button {
                        UIApplication.shared.open(addmissionSiteURL)
                    } label: {
                        Text("입학처 열기 🎓")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15)
                        .fill(.orange)
                        .frame(height: 30))
                    Button {
                        UIApplication.shared.open(websiteURL)
                    } label: {
                        Text("홈페이지 열기 🏫")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15)
                        .fill(.orange)
                        .frame(height: 30))
                }
            }
            .padding(.trailing, 10)
            .padding(.vertical, 10)
        }
        .frame(height: 200)
    }
    
    var depart: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("학과목록")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
            }
            .padding(.leading, 20)
            
            VStack(spacing: 30) {
                if let departmentResponses = viewModel.listDetail.departmentResponses {
                    ForEach(departmentResponses.indices, id: \.self) { index in
                        if let depart = departmentResponses[index],
                           let name = depart.name,
                           let type = depart.type {
                            VStack {
                                HStack {
                                    Text(type)
                                        .foregroundColor(.black)
                                        .font(.system(size: 14, weight: .bold))
                                    
                                    Spacer()
                                    
                                    Button {
                                        toggleDepart(departId: index)
                                    } label: {
                                        HStack(spacing: 30) {
                                            Text("\(name.count)개")
                                                .foregroundColor(.gray)
                                                .font(.system(size: 12, weight: .regular))
                                                .padding(.trailing, 10)
                                            
                                            Image(self.expandedDepartIds.contains(index) ? "arrow_down" : "arrow_fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 10, height: 10)
                                        }
                                    }
                                }
                                if self.expandedDepartIds.contains(index) {
                                    departCell(names: name)
                                }
                                Divider()
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 30)
        }
    }
    private func toggleDepart(departId: Int) {
        if expandedDepartIds.contains(departId) {
            expandedDepartIds.remove(departId)
        } else {
            expandedDepartIds.insert(departId)
        }
    }
}

fileprivate struct departCell: View {
    var names: [String]
    var body: some View {
        ForEach(names.indices, id: \.self) { index in
            HStack {
                Text("\(index+1). \(names[index])")
                    .font(.system(size: 12, weight: .semibold))
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(.horizontal, 40)
        }
        .padding(.vertical, 5)
    }
}

struct ListDetailView_PreViews: PreviewProvider {
    static var previews: some View {
        ListDetailView(viewModel: ListDetailViewModel(container: DIContainer(services: StubServices())), universityId: 0)
    }
}
