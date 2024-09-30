//
//  InitiativeView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import SwiftUI

struct InitiativeView: View {
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: InitiativeViewModel
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 30) {
                    Image("rank_poster")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.top, 20)
                    
                    Text("카테고리")
                        .padding(.leading, 20)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 5) {
                            ForEach(viewModel.category, id: \.self) { item in
                                categoryViewCell(categoryItem: item)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    SeperateView()
                        .frame(width: UIScreen.main.bounds.width, height: 20)
                    
                    Text("QS 세계대학평가")
                        .padding(.leading, 20)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    ForEach(viewModel.InitiativeData, id: \.rank) { cell in
                        InitiativeViewCell(model: cell)
                            .tag(cell.rank)
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
                        Image("initiative_navi")
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
}

fileprivate struct categoryViewCell: View {
    var categoryItem: Object
    
    var body: some View {
        NavigationLink(destination: EmptyView()) {
            VStack(spacing: 10) {
                Image(categoryItem.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.homeColor))
                
                Text(categoryItem.title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.black)
            }
        }
        .frame(width: 100, height: 100)
    }
}

struct InitiativeView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubServices())
    static let authViewModel = AuthViewModel(container: .init(services: StubServices()))
    static var previews: some View {
        InitiativeView(viewModel: InitiativeViewModel(container: Self.container))
            .environmentObject(Self.authViewModel)
            .environmentObject(Self.container)
    }
}

