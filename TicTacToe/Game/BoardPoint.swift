//
//  BoardPoint.swift
//  TicTacToe
//
//  Created by Romilson Nunes on 02/07/17.
//  Copyright © 2017 Romilson Nunes. All rights reserved.
//

import Foundation

struct BoardPoint: Hashable {
    
    let row: Int
    let column: Int
    
    init(column: Int, row: Int) {
        self.column = column
        self.row = row
    }
    
    var hashValue: Int {
        return  "\(row)-\(column)".hashValue
    }
    
    static func == (lhs: BoardPoint, rhs: BoardPoint) -> Bool {
        return lhs.row == rhs.row && lhs.column == rhs.column
    }
}
