//
//  FoodDetailViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 9/22/24.
//

import Foundation
import Combine

class FoodDetailViewModel: ObservableObject {
    
    @Published var phase: Phase = .notRequested
    @Published var data: [FoodModel] = [
        
    ]
    
}
