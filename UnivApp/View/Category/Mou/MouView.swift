//
//  MouView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import SwiftUI

struct MouView: View {
    @StateObject var viewModel: MouViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var mouTypeSelected: MouType? = nil
    @FocusState var isFocused: Bool
    
    var body: some View {
        contentView
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
    }
    
    @ViewBuilder
    var contentView: some View {
        switch self.viewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear {
                    viewModel.send(action: .load)
                }
        case .loading:
            LoadingView(url: "congratulations", size: [150,150])
        case .success:
            loadedView
                .alert(isPresented: $viewModel.textPhase) {
                    Alert(title: Text("검색 실패!"), message: Text("검색어와 일치하는 대학이 없습니다."), dismissButton: .default(Text("확인")))
                }
                .onTapGesture {
                    self.isFocused = false
                }
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 30) {
                searchView
                    .padding(.top, 20)
                
                HStack(spacing: 10) {
                    ForEach(MouType.allCases, id: \.self) { item in
                        Button {
                            if self.mouTypeSelected == item {
                                self.mouTypeSelected = nil
                                viewModel.send(action: .load)
                            } else {
                                self.mouTypeSelected = item
                                if item == .receipt {
                                    viewModel.send(action: .status("OPEN"))
                                } else {
                                    viewModel.send(action: .status("CLOSED"))
                                }
                            }
                        } label: {
                            Text(item.title)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(mouTypeSelected == item ? .orange : .black)
                                .frame(width: 80, height: 30)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(mouTypeSelected == item ? .orange : .gray, lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.leading, 20)
                
                SeperateView()
                    .frame(width: UIScreen.main.bounds.width, height: 20)
                
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 30) {
                        Group {
                            Text("\(viewModel.MouData.count)")
                                .font(.system(size: 12, weight: .heavy))
                            +
                            Text("건\t|   날짜순")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundColor(.black)
                        .padding(.leading, 20)
                        
                        ForEach(viewModel.MouData, id: \.self) { cell in
                            MouCell(model: cell)
                        }
                    }
                }
                .refreshable {
                    viewModel.send(action: .load)
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
                        Image("mou_navi")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 60)
                    }
                }
            }
        }
    }
    
    var searchView: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                Button {
                    if viewModel.searchText != "" {
                        viewModel.send(action: .search(viewModel.searchText))
                    }
                    viewModel.searchText = ""
                } label: {
                    Image("search")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                }
                .padding()
                
                TextField("키워드를 입력하세요", text: $viewModel.searchText)
                    .focused($isFocused)
                    .font(.system(size: 15, weight: .regular))
                    .padding()
                    .submitLabel(.search)
                    .onSubmit {
                        viewModel.send(action: .search(viewModel.searchText))
                        viewModel.searchText = ""
                        isFocused = false
                    }
            }
            .padding(.horizontal, 10)
            .background(Color.white)
            .border(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .leading, endPoint: .trailing), width: 1)
            .cornerRadius(15)
            .overlay (
                RoundedRectangle(cornerRadius: 15)
                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .leading, endPoint: .trailing), lineWidth: 1.5)
            )
        }
        .padding(.horizontal, 20)
    }
    
}

fileprivate struct MouCell: View {
    var model: MouModel
    @State var isPopup: Bool = false
    @State private var popupOpacity: Bool = false
    var body: some View {
        Button {
            withAnimation {
                self.isPopup = true
            }
        } label: {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(model.category)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Group {
                        if model.status == "접수 중" {
                            Text(model.status)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.orange).frame(width: 80, height: 30))
                        } else {
                            Text(model.status)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.gray).frame(width: 80, height: 30))
                        }
                    }
                    .padding(.trailing, 20)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundColor(.white)
                }
                
                Text(model.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack {
                    Text(model.date)
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.trailing)
                    Spacer()
                    Text("\(model.expoYear) 대입")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                }
                
                Divider()
            }
        }
        .padding(.horizontal, 20)
        .fullScreenCover(isPresented: $isPopup) {
            MouDetailView(model: model, isPopup: $isPopup)
                .presentationBackground(.black.opacity(0.3))
                .fadeInOut($popupOpacity)
        }
        .transaction { $0.disablesAnimations = true }
    }
}

struct MouView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices())
    static let authViewModel = AuthViewModel(container: .init(services: StubServices()), authState: .auth)
    static var previews: some View {
        MouView(viewModel: MouViewModel(container: Self.container))
            .environmentObject(Self.authViewModel)
            .environmentObject(Self.container)
    }
}

