//
//  TimeTableViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 3/3/25.
//

import Foundation
import Combine

final class TimeTableViewModel: ObservableObject {
    
    @Published var phase: Phase = .notRequested
    
}
