//
//  ListViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 3/2/25.
//

import Foundation
import Combine

final class ListViewModel: ObservableObject {
    
    @Published var phase: Phase = .notRequested
    
}
