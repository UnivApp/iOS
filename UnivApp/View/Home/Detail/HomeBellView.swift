//
//  BellView.swift
//  UnivApp
//
//  Created by 정성윤 on 11/1/24.
//

import SwiftUI

struct HomeBellView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        PlaceholderView()
    }
}

struct BellView_Previews: PreviewProvider {
    static var previews: some View {
        HomeBellView()
    }
}
