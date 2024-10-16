//
//  GraduateView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import SwiftUI

struct DiagnosisView: View {
    @StateObject var viewModel: DiagnosisViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                splashView
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
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
    
    var splashView: some View {
        VStack(alignment: .center, spacing: 20) {
            Image("DiagnosisTitle")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
            
            VStack {
                HStack {
                    ForEach(1..<3, id: \.self) { index in
                        if index == 1 {
                            LoadingView(url: "DG\(index)", size: [100, 100])
                            Spacer()
                        } else {
                            LoadingView(url: "DG\(index)", size: [100, 100])
                        }
                    }
                }
                LoadingView(url: "DG3", size: [100, 100])
                HStack {
                    ForEach(4..<6, id: \.self) { index in
                        if index == 4 {
                            LoadingView(url: "DG\(index)", size: [100, 100])
                            Spacer()
                        } else {
                            LoadingView(url: "DG\(index)", size: [100, 100])
                        }
                    }
                }
            }
            .padding(.horizontal, 50)
            
            VStack {
                Spacer()
                NavigationLink(destination: DiagnosisDetailView(viewModel: DiagnosisViewModel(container: .init(services: StubServices())))) {
                    Group {
                        Text("검사를 하려면 ")
                            .foregroundColor(.gray)
                        +
                        Text("터치")
                            .foregroundColor(.black)
                            .font(.system(size: 18, weight: .bold))
                        +
                        Text(" 하세요")
                            .foregroundColor(.gray)
                    }
                    .font(.system(size: 18, weight: .semibold))
                }
            }
            .padding(.bottom, 30)
        }
    }
}

struct DiagnosisView_Previews: PreviewProvider {
    static var previews: some View {
        DiagnosisView(viewModel: .init(container: .init(services: StubServices())))
    }
}
