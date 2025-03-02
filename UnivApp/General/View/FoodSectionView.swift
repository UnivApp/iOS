//
//  FoodSectionView.swift
//  UnivApp
//
//  Created by 정성윤 on 3/2/25.
//

import SwiftUI

struct FoodSectionView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
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
                        }
                        .font(.system(size: 15, weight: .semibold))
                        
                        ForEach(0...4, id: \.self) { tab in
                            Text("제육볶음")
                                .foregroundColor(.gray)
                                .font(.system(size: 13, weight: .semibold))
                        }
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.horizontal, 12)
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Spacer()
                    
                    Group {
                        HStack(spacing: 8) {
                            Text("저녁")
                                .foregroundColor(.black)
                            
                            Text("800kcal")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .font(.system(size: 15, weight: .semibold))
                        
                        ForEach(0...4, id: \.self) { tab in
                            Text("제육볶음")
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
        }
        .background(Color.clear)
    }
}

#Preview {
    FoodSectionView()
}
