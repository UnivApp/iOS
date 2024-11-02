//
//  DiagnosisResultView.swift
//  UnivApp
//
//  Created by 정성윤 on 10/16/24.
//

import SwiftUI
import Kingfisher

struct DiagnosisResultView: View {
    @StateObject var viewModel: DiagnosisResultViewModel
    @State private var opacity: Bool = false
    @State private var isLoaded: Bool = false
    @State private var loadingType: String = "load"
    
    var totalScore: Int
    var body: some View {
        contentView
    }
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear {
                    viewModel.send(action: .resultLoad(totalScore))
                }
        case .loading:
            LoadingView(url: "congratulations", size: [150, 150])
        case .success:
            contentLoadingView
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
        case .fail:
            ErrorView()
        }
    }
    
    var contentLoadingView: some View {
        Group {
            if isLoaded {
                loadedView
            } else {
                splashView
            }
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
        .fadeInOut($opacity)
    }
    
    var loadedView: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center, spacing: 10) {
                VStack(spacing: 0) {
                    Text("나와 잘 맞는 학과는")
                        .foregroundColor(.black)
                        .padding(.top, 20)
                    
                    if let departs = viewModel.result.recommand {
                        Text("\(departs)")
                            .foregroundColor(.orange)
                    }
                    Text("입니다")
                        .foregroundColor(.black)
                }
                .font(.system(size: 25, weight: .heavy))
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                
                if let diagnosisType = DiagnosisImageType(matchingResultType: viewModel.result.matchingResultType ?? "") {
                    Image(diagnosisType.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width / 1.3)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(viewModel.result.matchingResultType ?? "")
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
        .fadeInOut($opacity)
    }
}

#Preview {
    DiagnosisResultView(viewModel: DiagnosisResultViewModel(container: .init(services: StubServices())), totalScore: 0)
}
