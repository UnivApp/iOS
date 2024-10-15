//
//  ListCellView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/3/24.
//

import SwiftUI
import Kingfisher

struct ListViewCell: View {
    var model: SummaryModel
    
    @State private var heartTapped: Bool = false
    @StateObject var listViewModel: ListViewModel
    
    init(model: SummaryModel, listViewModel: ListViewModel){
        self.model = model
        _heartTapped = State(initialValue: model.starred ?? false)
        _listViewModel = StateObject(wrappedValue: listViewModel)
    }
    
    var body: some View {
        cell
    }
    
    var cell: some View {
        VStack(alignment: .center) {
            Spacer()
            
            HStack {
                Button {
                    self.heartTapped.toggle()
                    if heartTapped == true {
                        listViewModel.send(action: .addHeart(self.model.universityId ?? 0))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            listViewModel.send(action: .load)
                        }
                    } else {
                        listViewModel.send(action: .removeHeart(self.model.universityId ?? 0))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            listViewModel.send(action: .load)
                        }
                    }
                } label: {
                    if heartTapped == true {
                        Image("love_fill")
                            .resizable()
                            .frame(width: 12, height: 12)
                    } else {
                        Image("love_empty")
                            .resizable()
                            .frame(width: 12, height: 12)
                    }
                }
                .padding(.leading, 20)
                Spacer()
            }
            
            Spacer()
        
            if let url = URL(string: model.logo ?? "") {
                KFImage(url)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 30)
                    .background(.clear)
            }
            
            Spacer()
            
            Text(model.fullName ?? "")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black)
                .padding(.horizontal, 5)
            
            Spacer()
            
            HStack {
                Spacer()
                
                Text("\(model.starNum ?? 0)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.orange)
                    .padding(.trailing, 5)
                
                Image("star")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .padding(.trailing, 20)
            }
            
            Spacer()
            
            NavigationLink(destination: ListDetailView(viewModel: ListDetailViewModel(container: .init(services: Services())), universityId: model.universityId ?? 0)) {
                Text("정보보기")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.orange)
            }
            .frame(height: 30)
            .padding(.horizontal, 30)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.orange, lineWidth: 1)
            )
            
            Spacer()
            
        }
        .frame(width: 150, height: 250)
        .border(.gray, width: 0.5)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.bordergroundGray, lineWidth: 1.0)
        )
    }
}

#Preview {
    ListViewCell(model: .init(universityId: nil, fullName: nil, logo: nil, starNum: nil, starred: nil), listViewModel: ListViewModel(container: .init(services: StubServices()), searchText: ""))
}
