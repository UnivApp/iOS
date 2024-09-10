//
//  HeartViewCell.swift
//  UnivApp
//
//  Created by 정성윤 on 9/10/24.
//

import SwiftUI
import Kingfisher

struct HeartViewCell: View {
    var model: SummaryModel
    var destination: ListCellDestination?
    
    @State private var heartTapped: Bool = false
    @StateObject var heartViewModel: HeartViewModel
    
    init(model: SummaryModel, heartViewModel: HeartViewModel){
        self.model = model
        _heartTapped = State(initialValue: model.starred ?? false)
        _heartViewModel = StateObject(wrappedValue: heartViewModel)
    }
    
    var body: some View {
        cell
    }
    
    var cell: some View {
        VStack(alignment: .center) {
            Spacer()
            
            HStack {
                ZStack {
                    //TODO: - 즐겨찾기 수정
                    Image("love_circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Button {
                        self.heartTapped.toggle()
                        if heartTapped == true {
                            heartViewModel.send(action: .addHeart(self.model.universityId ?? 0))
//                            heartViewModel.send(action: .load)
                        } else {
                            heartViewModel.send(action: .removeHeart(self.model.universityId ?? 0))
//                            heartViewModel.send(action: .load)
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
                    .font(.system(size: 12))
                    .foregroundColor(.orange)
                    .padding(.trailing, 10)
                
                Image("star")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .padding(.trailing, 20)
            }
            
            Spacer()
            
            NavigationLink(destination: destination?.view) {
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

//#Preview {
//    HeartViewCell(model: .init(universityId: nil, fullName: nil, logo: nil, starNum: nil, starred: nil), heartViewModel: HeartViewModel(container: .init(services: StubServices())))
//}
