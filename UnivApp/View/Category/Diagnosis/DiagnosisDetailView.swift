//
//  DiagnosisDetailView.swift
//  UnivApp
//
//  Created by 정성윤 on 10/15/24.
//

import SwiftUI

struct DiagnosisDetailView: View {
    @StateObject var viewModel: DiagnosisViewModel
    @Environment(\.dismiss) var dismiss
    @State private var opacity: Double = 0
    @State private var diagnosisIndex: Int = 0
    @State private var isNext: Bool = false
    @State private var isResult: Bool = false
    
    var body: some View {
        contentView
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
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear {
                    viewModel.send(action: .questionLoad)
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
            if isResult {
                DiagnosisResultView(viewModel: DiagnosisResultViewModel(container: .init(services: Services())), totalScore: viewModel.totalAnswer.reduce(0, +))
            } else {
                VStack {
                    ProgressView(value: Double(diagnosisIndex) / Double(viewModel.question.count))
                        .tint(.orange)
                        .padding(.horizontal, 20)
                    
                    DiagnosisQuestionView(isNext: $isNext, model: viewModel.question[diagnosisIndex])
                        .environmentObject(viewModel)
                }
                .onChange(of: isNext) {
                    if isNext {
                        if self.diagnosisIndex < viewModel.question.count - 1 {
                            withAnimation {
                                self.diagnosisIndex += 1
                                self.isNext = false
                            }
                        } else {
                            self.isResult = true
                        }
                    }
                }
                .onAppear {
                    withAnimation {
                        opacity = 1
                    }
                }
                .onDisappear {
                    withAnimation {
                        opacity = 0
                    }
                }
                .opacity(opacity)
                .animation(.easeInOut(duration: 1.5), value: opacity)
            }
        }
    }
}

fileprivate struct DiagnosisQuestionView: View {
    @EnvironmentObject var viewModel: DiagnosisViewModel
    @Binding var isNext: Bool
    @State var isAlert: Bool = false
    
    var model: DiagnosisModel
    
    var body: some View {
        VStack(alignment: .center) {
            if let title = model.category,
               let questions = model.question {
                ScrollViewReader { proxy in
                    ScrollView(.vertical) {
                        VStack {
                            HStack {
                                Text(title)
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .id("category")
                            .padding(.top, 20)
                            
                            ForEach(questions.indices, id: \.self) { index in
                                VStack(alignment: .leading, spacing: 20) {
                                    Text(questions[index])
                                        .foregroundColor(.black)
                                        .font(.system(size: 15, weight: .semibold))
                                        .lineLimit(nil)
                                        .lineSpacing(5)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    DiagnosisSelectView(selectedPoint: $viewModel.selectedAnswer[index])
                                }
                                .padding(.vertical, 10)
                            }
                            
                            Button {
                                if viewModel.selectedAnswer.allSatisfy({ $0 > 0 }) {
                                    let totalScore = viewModel.calculateTotalScore(totalArray: viewModel.selectedAnswer)
                                    viewModel.totalAnswer.append(totalScore)
                                    viewModel.initArray()
                                    self.isNext = true
                                    proxy.scrollTo("category", anchor: .top)
                                } else {
                                    self.isAlert = true
                                }
                            } label: {
                                VStack(spacing: 5) {
                                    Text("저장 및 다음")
                                        .foregroundColor(viewModel.selectedAnswer.allSatisfy({ $0 > 0 }) ? .orange : .gray)
                                        .font(.system(size: 18, weight: .bold))
                                    
                                    Text(viewModel.selectedAnswer.allSatisfy({ $0 > 0 }) ? "저장 후 되돌릴 수 없어요" : "모든 항목을 선택해 주세요")
                                        .foregroundColor(viewModel.selectedAnswer.allSatisfy({ $0 > 0 }) ? .orange : .gray)
                                        .font(.system(size: 13, weight: .regular))
                                }
                                .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 20)
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
        .alert(isPresented: $isAlert) {
            Alert(title: Text("모든 항목을 선택해 주세요"), dismissButton: .default(Text("확인")))
        }
    }
}

fileprivate struct DiagnosisSelectView: View {
    @State private var buttonType: DiagnosisButton? = nil
    @Binding var selectedPoint: Int
    var body: some View {
        HStack {
            ForEach(DiagnosisButton.allCases, id: \.self) { button in
                Button {
                    if buttonType == button {
                        buttonType = nil
                        selectedPoint = 0
                    } else {
                        buttonType = button
                        selectedPoint = button.point
                    }
                } label: {
                    Text(button.title)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 15).fill(self.buttonType == button ? .orange : .backGray))
                        .foregroundColor(self.buttonType == button ? .white : .gray)
                        .font(.system(size: 12, weight: .heavy))
                }
                
            }
        }
        .onChange(of: selectedPoint) {
            if selectedPoint == 0 {
                buttonType = nil
            }
        }
    }
}

#Preview {
    DiagnosisDetailView(viewModel: DiagnosisViewModel(container: .init(services: StubServices())))
}
