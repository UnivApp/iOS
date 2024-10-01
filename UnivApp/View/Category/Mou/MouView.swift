//
//  MouView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import SwiftUI

struct MouView: View {
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: MouViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var mouTypeSelected: MouType? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 30) {
                    HStack(spacing: 10) {
                        ForEach(MouType.allCases, id: \.self) { item in
                            Button {
                                self.mouTypeSelected = item
                                if item == .receipt {
                                    //TODO: - 접수 중 로드
                                } else {
                                    //TODO: - 접수종료 로드
                                }
                            } label: {
                                Text(item.title)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(mouTypeSelected == item ? .blue : .black)
                                    .frame(width: 80, height: 30)
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(mouTypeSelected == item ? . blue : .gray, lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.leading, 20)
                    .padding(.top, 20)
                    
                    SeperateView()
                        .frame(width: UIScreen.main.bounds.width, height: 20)
                    
                    Group {
                        Text("\(viewModel.MouData.count)")
                            .font(.system(size: 12, weight: .heavy))
                        +
                        Text("건\t|   날짜순")
                            .font(.system(size: 12, weight: .regular))
                    }
                    .foregroundColor(.black)
                    .padding(.leading, 20)
                    
                    ForEach(viewModel.MouData, id: \.self) { cell in
                        MouCell(model: cell)
                    }
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
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
}

fileprivate struct MouCell: View {
    var model: MouModel
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            //TODO: - NavigationLink

            HStack {
                Text(model.category)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                Spacer()
                Group {
                    if model.receipt == "접수 중" {
                        Text(model.receipt)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.blue).frame(width: 80, height: 30))
                    } else {
                        Text(model.receipt)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.gray).frame(width: 80, height: 30))
                    }
                }
                .padding(.trailing, 20)
                .multilineTextAlignment(.center)
                .font(.system(size: 13, weight: .heavy))
                .foregroundColor(.white)
            }

            
            Text(model.title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack {
                Text(model.date)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.trailing)
                Spacer()
                Text(model.schoolName)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.trailing)
            }
            
            Divider()
        }
        .padding(.horizontal, 20)
    }
}

struct MouView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices())
    static let authViewModel = AuthViewModel(container: .init(services: StubServices()))
    static var previews: some View {
        MouView(viewModel: MouViewModel(container: Self.container))
            .environmentObject(Self.authViewModel)
            .environmentObject(Self.container)
    }
}

