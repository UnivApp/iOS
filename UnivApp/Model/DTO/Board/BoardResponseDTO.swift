//
//  BoardResponseDTO.swift
//  UnivApp
//
//  Created by 정성윤 on 3/18/25.
//

import Foundation

struct BoardResponseDTO: Decodable {
    let boardId: Int
    let title: String
}

extension BoardResponseDTO {
    func toEntity() -> BoardEntity {
        return BoardEntity(
            title: self.title,
            boardId: self.boardId
        )
    }
}
