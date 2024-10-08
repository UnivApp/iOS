//
//  InitiativeDetailView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/5/24.
//

import SwiftUI

enum CWTSType: String, CaseIterable, Hashable {
    case general
    case p
    case pp
    var title: String {
        switch self {
        case .general:
            return "P"
        case .p:
            return "P(top 10%)"
        case .pp:
            return "PP(top 10%)"
        }
    }
}

struct InitiativeDetailView: View {
    @Environment(\.dismiss) var dismiss
    var model: [InitiativeModel]
    var title: String
    
    @State private var segmentType: CWTSType = .general
    @State private var cwtsmodel: [InitiativeModel] = []
    var body: some View {
        loadedView
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
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
            .onAppear {
                self.filterCWTSModel()
            }
    }
    var loadedView: some View {
        VStack(spacing: 30) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(model.compactMap { $0.fullName }.first ?? "")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(model.compactMap { $0.description }.first ?? "")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.gray)
                    
                    Text("\(model.compactMap { $0.year }.first ?? 0)년도")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top, 10)
                }
                .lineSpacing(5)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            if title == "CWTS" {
                HStack {
                    ForEach(CWTSType.allCases, id: \.self) { selected in
                        Button {
                            self.segmentType = selected
                            self.filterCWTSModel()
                        } label: {
                            Text(selected.title)
                                .padding()
                                .foregroundColor(.black)
                                .font(.system(size: 15, weight: .bold))
                                .background(RoundedRectangle(cornerRadius: 15)
                                    .fill(segmentType == selected ? .yellow : .backGray)
                                    .frame(height: 40))
                        }
                    }
                }
                ScrollView(.vertical) {
                    ForEach(cwtsmodel.indices, id: \.self) { index  in
                        InitiativeViewCell(model: cwtsmodel[index])
                    }
                }
            } else {
                ScrollView(.vertical) {
                    ForEach(model.indices, id: \.self) { index  in
                        InitiativeViewCell(model: model[index])
                    }
                }
            }
        }
    }
    private func filterCWTSModel() {
        switch self.segmentType {
        case .general:
            self.cwtsmodel = model.filter { item in
                item.category == "P"
            }
        case .p:
            self.cwtsmodel = model.filter { item in
                item.category == "P_TOP_10"
            }
        case .pp:
            self.cwtsmodel = model.filter { item in
                item.category == "PP_TOP_10"
            }
        }
    }
}

#Preview {
    InitiativeDetailView(model: [InitiativeModel(displayName: "", fullName: "세계대학평가", description: "어쩌고저쩌고", year: 0, universityRankingResponses: [UniversityRankingResponses(universityName: "", logo: "", rank: 0)])], title: "CWTS")
}
