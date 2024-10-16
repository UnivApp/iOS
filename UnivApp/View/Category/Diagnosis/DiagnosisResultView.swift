//
//  DiagnosisResultView.swift
//  UnivApp
//
//  Created by 정성윤 on 10/16/24.
//

import SwiftUI
import Kingfisher

struct DiagnosisResultView: View {
    @StateObject var viewModel: DiagnosisViewModel
    @State private var splashOpacity: Double = 0
    @State private var loadedOpacity: Double = 0
    @State private var isLoaded: Bool = false
    @State private var loadingType: String = "load"
    
    var body: some View {
        contentView
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.loadingType = "star"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.loadingType = "firework"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.isLoaded = true
                        }
                    }
                }
            }
    }
    @ViewBuilder
    var contentView: some View {
        if isLoaded {
            loadedView
        } else {
            splashView
        }
    }
    
    var splashView: some View {
        VStack(alignment: .center, spacing: 50) {
            Spacer()
            Group {
                Text(loadingType == "firework" ? "유형 분석이\n" : "결과를 토대로\n")
                    .foregroundColor(.black)
                +
                Text(loadingType == "firework" ? "완료 " : "분석 중")
                    .foregroundColor(.orange)
                +
                Text(loadingType == "firework" ? "되었습니다" : " 입니다")
                    .foregroundColor(.black)
            }
            .font(.system(size: 30, weight: .heavy))
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            .padding(.top, 20)
            
            LoadingView(url: self.loadingType, size: [150, 150])
            Spacer()
        }
        .onAppear {
            withAnimation {
                splashOpacity = 1
            }
        }
        .onDisappear {
            withAnimation {
                splashOpacity = 0
            }
        }
        .opacity(splashOpacity)
        .animation(.easeInOut(duration: 1.5), value: splashOpacity)
    }
    
    var loadedView: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center, spacing: 10) {
                VStack(spacing: 0) {
                    Text("나와 잘 맞는 학과는")
                        .foregroundColor(.black)
                        .padding(.top, 20)
                    
                    if let departs = viewModel.result.recommand {
                        HStack(spacing: 3) {
                            ForEach(departs.indices, id: \.self) { index in
                                Text("\(departs[index])")
                                    .foregroundColor(.orange)
                                if index != departs.count - 1 {
                                    Text(",")
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                    Text("입니다")
                        .foregroundColor(.black)
                }
                .font(.system(size: 25, weight: .heavy))
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                
                Image("ResearchType")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width / 1.3)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(viewModel.result.type ?? "")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(viewModel.result.description ?? "")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black.opacity(0.7))
                }
                .padding(.bottom, 30)
                .lineSpacing(5)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            withAnimation {
                loadedOpacity = 1
            }
        }
        .onDisappear {
            withAnimation {
                loadedOpacity = 0
            }
        }
        .opacity(loadedOpacity)
        .animation(.easeInOut(duration: 1.5), value: loadedOpacity)
    }
}

#Preview {
    DiagnosisResultView(viewModel: DiagnosisViewModel(container: .init(services: StubServices())))
}
