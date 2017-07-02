//
//  Player.swift
//  TicTacToe
//
//  Created by Romilson Nunes on 02/07/17.
//  Copyright © 2017 Romilson Nunes. All rights reserved.
//

import UIKit

/* Board
 
 [1]-[2]-[3]
 [1]-[2]-[3]
 [1]-[2]-[3]
 
 (1)-(1)-(1)
 (2)-(2)-(2)
 (3)-(3)-(3)
 
 Win:
 1) Line completed
 2) Collum completed
 3) Diagnal completed
 
 */

enum GameResult {
    case tie // empate
    case victory(Player)
}

protocol GameManagerDelegate: class {
    func gameReseted(manager: GameManager)
    func gameManager(_ manager: GameManager, finishedWith result: GameResult)
    func gameManager(_ manager: GameManager, didSelected point: BoardPoint, from player: Player)
}

class GameManager {
    
    weak var delegate: GameManagerDelegate?

    private(set) var lastPlayer: Player?
    
    private(set) var board = GameBoard()
    
    
    func reset() {
        self.board = GameBoard()
        self.delegate?.gameReseted(manager: self)
    }
    
    func canSelect(point: BoardPoint, from player: Player) -> Bool {
        if let last = self.lastPlayer, last == player {
            return false
        }
        return self.board.canSelect(point: point)
    }
    
    func select(point: BoardPoint, from player: Player) {
        self.board.select(point: point, from: player)
        
        defer {
            self.lastPlayer = player
            self.delegate?.gameManager(self, didSelected: point, from: player)
        }
        
        // 1.) Verificar vencedor
        if checkVictory(from: player) {
            self.delegate?.gameManager(self, finishedWith: GameResult.victory(player))
            return
        }
        
        // 2.) Verificar fim do jogo (board full)
        if board.isFull() {
            self.delegate?.gameManager(self, finishedWith: .tie)
            return
        }
    }
    
    
    // MARK: - Check Victory
    
    private func checkVictory(from player: Player) -> Bool {
        return anyColumnCompleted(from: player) || anyRowCompleted(from: player) || anyDiagonalCompleted(from: player)
    }
    
    private func anyColumnCompleted(from player: Player) -> Bool {
        for column in board.columns {
            var sum = 0
            for row in board.rows {
                let point = BoardPoint(column: column, row: row)
                if let boardPlayer = board[point], boardPlayer == player {
                    sum += 1
                }
            }
            if sum == 3 {
                return true
            }
        }
        return false
    }
    
    private func anyRowCompleted(from player: Player) -> Bool {
        for row in board.rows {
            var sum = 0
            for column in board.columns  {
                let point = BoardPoint(column: column, row: row)
                if let boardPlayer = board[point], boardPlayer == player {
                    sum += 1
                }
            }
            if sum == 3 {
                return true
            }
        }
        return false
    }
    
    private func anyDiagonalCompleted(from player: Player) -> Bool {
        var diagonalTopBottom = 0
        var diagonalBottomTop = 0
        for column in board.columns {
            for row in board.rows  {
                let point = BoardPoint(column: column, row: row)
                if let boardPlayer = board[point], boardPlayer == player {
                    // First
                    if column == 0 && row == 0 {
                        diagonalTopBottom += 1
                    }
                    if column == 0 && row == 2 {
                        diagonalBottomTop += 1
                    }
                    
                    // Middle
                    if column == 1 && row == 1 {
                        diagonalTopBottom += 1
                        diagonalBottomTop += 1
                    }
                    
                    // Last
                    if column == 2 && row == 2 {
                        diagonalTopBottom += 1
                    }
                    if column == 2 && row == 0 {
                        diagonalBottomTop += 1
                    }
                }
            }
        }
        return (diagonalTopBottom == 3) || (diagonalBottomTop == 3)
    }
}


struct GameBoard {
    
    let sideSize = 3
    
    // var numberOfItems: Int { return sideSize * sideSize }
    
    lazy var columns : [Int] = [0,1,2]
    lazy var rows : [Int] = [0,1,2]
    
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
}

struct Player {
    let identifier: String // 'X' or 'O'
    let image: UIImage
    
    init(identifier: String, image: UIImage) {
        self.identifier = identifier
        self.image = image
    }
    
    static func ==(lhs: Player, rhs: Player) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}


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

/*
struct Piece {
    let column: Int
    let row: Int
    
    let identifier: String // 'x' or 'o'
    
    init(identifier: String, column: Int, row: Int) {
        self.identifier = identifier
        self.column = column
        self.row = row
    }
}
*/
