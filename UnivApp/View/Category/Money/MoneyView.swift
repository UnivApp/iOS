//
//  MoneyView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import SwiftUI
import Charts

struct MoneyView: View {
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: MoneyViewModel
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationStack {
            VStack {
                search
                    .padding(.bottom, 20)
                    .padding(.top, 20)
                
                Spacer()
                
                ScrollView(.vertical) {
                    graph
                }
                .padding(.horizontal, 0)
                .padding(.bottom, 0)
                .refreshable {
                    
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
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
    
    var search: some View {
        HStack {
            Group {
                Button {
                    //TODO: 검색
                } label: {
                    Image("search")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .padding()
                
                TextField("대학명/소재지를 입력하세요", text: $viewModel.searchText)
                    .font(.system(size: 17, weight: .bold))
                    .padding()
            }
            .padding(.leading, 10)
        }
        .background(Color(.backGray))
        .cornerRadius(15)
        .padding(.horizontal, 30)
    }
    
    var graph: some View {
        VStack(spacing: 10) {
            HScrollView(title: [Text("대학 주변의 "), Text("평균 월세 "), Text("확인하기")], array: [Object(title: "세종대학교", image: "emptyLogo"), Object(title: "세종대학교", image: "emptyLogo"), Object(title: "세종대학교", image: "emptyLogo"), Object(title: "세종대학교", image: "emptyLogo"), Object(title: "세종대학교", image: "emptyLogo")], pointColor: .pointColor, size: 30)
                .background(.backGray)
            
            Group {
                Chart {
                    ForEach(viewModel.dataPoints, id: \.self) { point in
                        BarMark(x: .value("년도", point.label), y: .value("원", point.value))
                            .foregroundStyle(Color.pointColor)
                        PointMark(x: .value("년도", point.label), y: .value("원", point.value))
                            .foregroundStyle(Color.black)
                        LineMark(x: .value("년도", point.label), y: .value("원", point.value))
                            .foregroundStyle(Color.black)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 30)
                .frame(maxWidth: .infinity)
                .frame(height: 350)
                .scaledToFit()
            }
            .border(.backGray, width: 2)
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
    }
    
}

struct MoneyView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices())
    static let authViewModel = AuthViewModel(container: .init(services: StubServices()))
    static var previews: some View {
        MoneyView(viewModel: MoneyViewModel(searchText: "", container: Self.container))
            .environmentObject(Self.authViewModel)
            .environmentObject(Self.container)
    }
}

