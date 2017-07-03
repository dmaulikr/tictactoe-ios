//
//  AIEnginer.swift
//  TicTacToe
//
//  Created by Romilson Nunes on 02/07/17.
//  Copyright © 2017 Romilson Nunes. All rights reserved.
//

import Foundation


class AIEnginer {
    
    func predictNextPosition(forPlayer player: Player, inBoard board: Board, withOpponent opponent: Player,completion : @escaping ( BoardPoint ) -> Void ) {
        
        DispatchQueue.global(qos: .background).async {
            
            let mainNode = NodeMiniMax(procedure: .max, board: board)
            
            // Configure nodes
            self.configureChildNodes(from: mainNode, player: player, opponent: opponent)
            
            // Check best node
            let bestNode = self.getBestScore(procedure: .max, from: mainNode.nodes, player: player, opponent: opponent)
            
            guard let point = bestNode.point else {
                return
            }
            
            DispatchQueue.main.async {
                completion(point)
            }
        }
    }
    
    fileprivate func configureChildNodes(from node: NodeMiniMax, player: Player, opponent: Player) {
        
        var boardCopy = node.board
        let procedure = node.procedure.toggle()
        let nextPlayer = procedure == .min ? player : opponent

        for point in boardCopy.emptyPoints() {

            let childNode = NodeMiniMax(procedure: procedure, board: boardCopy)
            childNode.setStep(point: point, player: nextPlayer)
            node.nodes.append(childNode)
            
            guard !node.anyVictory(player: player, opponent: opponent) else {
                return
            }
            
            guard !node.completed() else {
                return
            }
            
            configureChildNodes(from: childNode, player: player, opponent: opponent)
        }
    }
    
    fileprivate func getBestScore(procedure: ProcedureType, from nodes: [NodeMiniMax], player: Player, opponent: Player) -> NodeMiniMax {
        
        var best: NodeMiniMax! // node.first!
        for node in nodes {
//           // first
            if best == nil {
                best = node
            }
            
            node.value = miniMaxValue(procedure: procedure, from: node.nodes, player: player, opponent: opponent)
            
            if procedure == .max, node.value > best.value {
                best = node
            } else if procedure == .min, node.value < best.value {
                best = node
            }
        }
        
        return best
    }
    
    fileprivate func miniMaxValue(procedure: ProcedureType, from nodes: [NodeMiniMax], player: Player, opponent: Player) -> Int {
        
        var value = 0
        
        for node in nodes {
            if node.nodes.count > 0 {
                value = miniMaxValue(procedure: procedure.toggle(), from: node.nodes, player: player, opponent: opponent)
            } else {
                // TODO: - Refatorar.. juntar if's interno
                if procedure == .max {
                    if node.manager.checkVictory(from: player) {
                        value = 1
                    }
                } else if procedure == .min {
                    if node.manager.checkVictory(from: opponent) {
                        value = -1
                    }
                }
            }
        }
        
        if value == 0 {
            print("Deu ruim")
        }
        
        return value
    }
    
}


fileprivate enum ProcedureType: Int {
    case max
    case min
    
    static func ==(lhs: ProcedureType, rhs: ProcedureType) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    func toggle() -> ProcedureType {
        return (self == .max) ? .min : .max
    }
}

fileprivate class NodeMiniMax {
    
    // Arvore de Pronfundidade
    // +1 vitória MAX (x)
    // -1 Vitória de MIN (o)
    //  0 Empate
    //  -2 Empty
    
    var value: Int = 0
    
    let procedure: ProcedureType
    
    var nodes: [NodeMiniMax] = []

    private(set) var board: Board
    private(set) var point: BoardPoint?
    
    private(set) lazy var manager: GameManager = { return GameManager(board: self.board)}()

    
    // Initializers
    
    init(procedure: ProcedureType, board: Board) {
        self.procedure = procedure
        self.board = board
    }
    
    
    // MARK: - Helper
    
    func setStep(point: BoardPoint, player: Player) {
        self.board.select(point: point, from: player)
        self.point = point
    }
    
    func completed() -> Bool {
        return self.board.isFull()
    }
    
    func anyVictory(player: Player, opponent: Player) -> Bool {
        let manager = GameManager(board: self.board)
        if manager.checkVictory(from: player) {
            return true
        }
        return manager.checkVictory(from: opponent)
    }
}

