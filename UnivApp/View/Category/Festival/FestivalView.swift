//
//  FestivalView.swift
//  UnivApp
//
//  Created by 정성윤 on 11/2/24.
//

import SwiftUI

enum FestivalType: String, CaseIterable {
    case festival
    case school
    
    var title: String {
        switch self {
        case .festival:
            return "축제"
        case .school:
            return "학교"
        }
    }
}

struct FestivalView: View {
    @StateObject var viewModel: FestivalViewModel
    @State var type: FestivalType = .festival
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        contentView
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
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
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear {
                    viewModel.send(action: .topLoad)
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
            VStack(alignment: .center, spacing: 20) {
                HStack(spacing: 10) {
                    ForEach(FestivalType.allCases, id: \.self) { segment in
                        Button {
                            self.type = segment
                        } label: {
                            Text(segment.title)
                                .padding()
                                .foregroundColor(.black)
                                .font(.system(size: 15, weight: .bold))
                                .background(RoundedRectangle(cornerRadius: 15)
                                    .fill(type == segment ? .yellow : .backGray)
                                    .frame(height: 40))
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                Group {
                    if type == .festival {
                        FestivalSegmentView(model: viewModel.talentData)
                    } else {
                        FestivalSchoolView(viewModel: viewModel, listViewModel: ListViewModel(container: .init(services: Services()), searchText: ""))
                    }
                }
            }
        }
    }
}

#Preview {
    FestivalView(viewModel: .init(container: .init(services: StubServices())))
}
