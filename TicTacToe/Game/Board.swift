//
//  Board.swift
//  TicTacToe
//
//  Created by Romilson Nunes on 02/07/17.
//  Copyright © 2017 Romilson Nunes. All rights reserved.
//

import Foundation

struct Board {
    
    static let sideSize = 3
    var numberOfItems: Int { return Board.sideSize * Board.sideSize }
    
    // TODO: - Change to [0..<Board.sideSize]
    lazy var rows    : [Int] = [0,1,2]
    lazy var columns : [Int] = [0,1,2]
    
    private var data : [BoardPoint: Player] = [:]
    
    subscript(point: BoardPoint) -> Player? {
        get {
            return self.data[point]
        }
        set {
            self.data[point] = newValue
        }
    }
    
    
    // MARK: - Public
    
    mutating func isFull() -> Bool {
        for column in columns {
            for row in rows {
                if canSelect(point: BoardPoint(column: column, row: row)) {
                    return false
                }
            }
        }
        return true
    }
    
    func canSelect(point: BoardPoint) -> Bool {
        return self[point] == nil
    }
    
    mutating func select(point: BoardPoint, from player: Player) {
        if self.canSelect(point: point) {
            self[point] = player
        }
    }
    
    mutating func emptyPoints() -> [BoardPoint] {
        var points: [BoardPoint] = []
        for row in rows {
            for column in columns {
                let point = BoardPoint(column: column, row: row)
                if canSelect(point: point) {
                    points.append(point)
                }
            }
        }
        return points
    }
}
