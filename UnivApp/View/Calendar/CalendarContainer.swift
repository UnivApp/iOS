//
//  CalendarContainer.swift
//  UnivApp
//
//  Created by 정성윤 on 10/17/24.
//

import SwiftUI

struct CalendarContainer: View {
    @StateObject var viewModel: CalendarViewModel
    @State var isSelected: Bool = false
    @State var opacity: Double = 0

    var body: some View {
        contentView
            .onChange(of: viewModel.selectedCalendar) {
                self.isSelected = !viewModel.selectedCalendar.isEmpty
            }
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            loadedView
                .onAppear {
                    viewModel.send(action: .totalLoad)
                }
        case .loading:
            LoadingView(url: "congratulations", size: [150, 150])
        case .success:
            loadedView
                .refreshable {
                    viewModel.send(action: .totalLoad)
                    viewModel.selectedCalendar = []
                }
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 20) {
                    CalendarView(calenderData: viewModel.calendarData, selectedData: $viewModel.selectedCalendar)
                        .frame(height: isSelected ? UIScreen.main.bounds.height / 1.7 : UIScreen.main.bounds.height / 1.2)
                        .animation(.easeInOut, value: isSelected)
                        .padding(.horizontal, -10)
                    
                    ForEach(viewModel.selectedCalendar, id: \.id) { item in
                        CalendarDataCell(model: item)
                            .environmentObject(viewModel)
                    }
                    .onAppear {
                        opacity = 1
                    }
                    .onDisappear {
                        opacity = 0
                    }
                    .opacity(opacity)
                    .animation(.easeInOut, value: opacity)
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct CalendarContainer_Previews: PreviewProvider {
    static var previews: some View {
        CalendarContainer(viewModel: CalendarViewModel(container: .init(services: StubServices())))
    }
}
