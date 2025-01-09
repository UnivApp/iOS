//
//  SettingBellView.swift
//  UnivApp
//
//  Created by 정성윤 on 1/9/25.
//

import SwiftUI

struct SettingBellView: View {
    @Binding var isPresented: Bool
    var cases: SettingType
    var body: some View {
        NavigationLink(destination: BellView(viewModel: .init(container: .init(services: Services())), isPopup: $isPresented)) {
            VStack(spacing: 20) {
                HStack {
                    HStack(alignment: .center, spacing: 20) {
                        Image(systemName: cases.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black.opacity(0.7))
                        
                        VStack(alignment: .leading) {
                            Text(cases.title)
                                .foregroundColor(.black.opacity(0.7))
                                .font(.system(size: 13, weight: .bold))
                            
                            Text(cases.description)
                                .foregroundColor(.gray)
                                .font(.system(size: 12, weight: .regular))
                        }
                        Spacer()
                        Image("arrow_fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                    }
                    .multilineTextAlignment(.leading)
                }
                Divider()
            }
            .padding(.vertical, 5)
        }
    }
}

//#Preview {
//    SettingBellView()
//}
