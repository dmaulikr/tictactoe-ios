//
//  Player.swift
//  TicTacToe
//
//  Created by Romilson Nunes on 02/07/17.
//  Copyright © 2017 Romilson Nunes. All rights reserved.
//

import Foundation

// MARK: - Enum

enum GameResult {
    case tie // empate
    case victory(Player)
}


// MARK: - Protocols

protocol GameManagerDelegate: class {
    func gameReseted(manager: GameManager)
    func gameManager(_ manager: GameManager, finishedWith result: GameResult)
    func gameManager(_ manager: GameManager, didSelected point: BoardPoint, from player: Player)
}


// MARK: - Class Manager

class GameManager {
    
    weak var delegate: GameManagerDelegate?

    private(set) var lastPlayer: Player?
    
    private(set) var board = Board()
    
    
    // MARK: - Public
    
    func reset() {
        self.board = Board()
        self.lastPlayer = nil
        self.delegate?.gameReseted(manager: self)
    }
    
    func player(at point: BoardPoint) -> Player? {
        return board[point]
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
        }
    }
    
    
    // MARK: - Check State
    
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
            if sum == Board.sideSize {
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
            if sum == Board.sideSize {
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
        return (diagonalTopBottom == Board.sideSize) || (diagonalBottomTop == Board.sideSize)
    }
}


