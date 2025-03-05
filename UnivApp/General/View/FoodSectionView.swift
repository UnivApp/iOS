//
//  FoodSectionView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/2/25.
//

import SwiftUI

struct FoodSectionView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 24) {
                Group {
                    VStack(alignment: .leading, spacing: 12) {
                        Spacer()
                        
                        Group {
                            HStack(spacing: 8) {
                                Text("점심")
                                    .foregroundColor(.black)
                                
                                Text("720kcal")
                                    .foregroundColor(.gray)
                                Spacer()
                                Image("sun")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            }
                            .font(.system(size: 15, weight: .semibold))
                            
                            ForEach(0...3, id: \.self) { tab in
                                Text("해파리냉채제육덮밥")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 13, weight: .semibold))
                            }
                        }
                        .font(.system(size: 15, weight: .semibold))
                        .padding(.horizontal, 12)
                        
                        Spacer()
                    }
                    .frame(width: 250, height: 200)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Spacer()
                        
                        Group {
                            HStack(spacing: 8) {
                                Text("저녁")
                                    .foregroundColor(.black)
                                
                                Text("800kcal")
                                    .foregroundColor(.gray)
                                Spacer()
                                Image("moon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            }
                            .font(.system(size: 15, weight: .semibold))
                            
                            ForEach(0...3, id: \.self) { tab in
                                Text("해파리냉채제육덮밥")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 13, weight: .semibold))
                            }
                        }
                        .padding(.horizontal, 12)
                        
                        Spacer()
                    }
                }
                .background(.white)
                .clipped()
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 0)
                .frame(width: 250, height: 200)
                
            }
            .padding(.vertical, 12)
        }
    }
}

#Preview {
    FoodSectionView()
}
