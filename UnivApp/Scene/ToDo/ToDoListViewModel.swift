//
//  ToDoListViewModel.swift
//  UnivApp
//
//  Created by 정성윤 on 3/17/25.
//

import Foundation
import Combine

final class ToDoListViewModel: ObservableObject {
    
    enum Action {
        
    }
    
    @Published var phase: Phase = .notRequested
    private var subscriptions = Set<AnyCancellable>()
    
    func sendAction(_ action: Action) {
        
    }
    
    
    @Published var toDoItems: [String: [(String, Bool)]] = [
        "2025-03-03": [("수학 문제 풀기", false), ("영어 단어 외우기", true)],
        "2025-03-04": [("체육복 챙기기", false), ("역사 숙제하기", false)]
    ]
    
    func addNewToDoItem(for date: String) {
        let newItem = "새로운 할 일 \(Int.random(in: 1...100))"
        if toDoItems[date] != nil {
            toDoItems[date]?.append((newItem, false))
        } else {
            toDoItems[date] = [(newItem, false)]
        }
    }
    
    func toggleComplete(for date: String, index: Int) {
        toDoItems[date]?[index].1.toggle()
    }
    
    func deleteItem(for date: String, at offsets: IndexSet) {
        toDoItems[date]?.remove(atOffsets: offsets)
        if toDoItems[date]?.isEmpty == true {
            toDoItems.removeValue(forKey: date)
        }
    }
    
    
}
