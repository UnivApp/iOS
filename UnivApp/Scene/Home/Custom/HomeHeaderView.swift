//
//  HomeHeaderView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/17/25.
//

import SwiftUI

struct HomeHeaderView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            HomeProfileView()
                .padding(.horizontal, 24)
            
            let columns = Array(repeating: GridItem(.flexible()), count: 5)
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(HomeCategoryType.allCases, id: \.self) { category in
                    NavigationLink(destination: category.view) {
                        VStack {
                            Image(systemName: category.image)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.black)
                                .frame(width: 30, height: 30)
                            
                            Text(category.rawValue)
                                .foregroundColor(.gray)
                                .font(.system(size: 10, weight: .semibold))
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            
            AnnouncementView()
        }
        .padding(.vertical, 24)
    }
}

fileprivate struct AnnouncementView: View {
    //TODO: 공지사항 모델 2개
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Group {
                HStack {
                    Spacer()
                    Label {
                        Text("지금은 체육시간 입니다!")
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .regular))
                            .padding(.horizontal, 8)
                    } icon: {
                        Image(systemName: "speaker.wave.2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(Color.customRed)
                .cornerRadius(15)
                .clipped()
                
                HStack {
                    Spacer()
                    Label {
                        Text("지금은 공기놀이 할 시간 입니다!")
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .regular))
                            .padding(.horizontal, 8)
                    } icon: {
                        Image(systemName: "checkmark.seal.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(Color.customBlue)
                .cornerRadius(15)
                .clipped()
            }
        }
        .padding(.horizontal)
    }
    
}


#Preview {
    HomeHeaderView()
        .environmentObject(HomeViewModel())
}
