//
//  BellView.swift
//  UnivApp
//
//  Created by 정성윤 on 11/1/24.
//

import SwiftUI

struct BellView: View {
    @StateObject var viewModel: CalendarViewModel
    @Binding var isPopup: Bool
    @State private var isAlert: Bool = false
    
    var body: some View {
        loadedView
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear {
                    viewModel.send(action: .getAlarm)
                }
        case .loading:
            LoadingView(url: "congratulations", size: [150, 150])
        case .success:
            loadedView
        case .fail:
            ErrorView()
        }
    }
    var loadedView: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        self.isPopup = false
                    }
                } label: {
                    Image("close_black")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            ScrollView(.vertical) {
                ForEach(viewModel.alarmData.indices, id: \.self) { index in
                    
                }
            }
        }
        .background(.white)
    }
}

struct BellView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isAlert: Bool = false
        BellView(viewModel: CalendarViewModel(container: .init(services: StubServices())), isPopup: $isAlert)
    }
}
