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
            let mainNode = Node(board: board, player: player)
            
            // Configure nodes
            self.configureChilds(from: mainNode, player: player, opponent: opponent)
            
            
            var max: Int?
            var options: [Node] = [];	// array das opções de jogadas
            
            // avalia qual a melhor opção de jogada, dentre as possíveis (filhos do estado atual)
            for node in mainNode.childs {
                if let _ = node.minimax, (max == nil || node.minimax! > max!)  {
                    max = node.minimax! // salva maior valor minimax dos filhos
                }
            }
            
            // percorre novamente os filhos, checando todos que tenham o mesmo valor minimax ótimo
            for node in mainNode.childs {
                if (node.minimax == max) {
                    options.append(node) // coloca índice deste filho no array de opções de jogada
                }
            }
            
            // e escolhe aleatoriamente um deles, para dar mais variedade às jogadas
            let randomIndex = Int(arc4random_uniform(UInt32(options.count)))
            guard let point = options[randomIndex].point else {
                return
            }
            
            DispatchQueue.main.async {
                completion(point)
            }
            
        }
        
//        DispatchQueue.global(qos: .background).async {
//            
//            let mainNode = Node(procedure: .max, board: board, player: player)
//            
//            // Configure nodes
//            self.configureChildNodes(from: mainNode, player: player, opponent: opponent)
//            
//            // Check best node
//            let bestNode = self.getBestScore(procedure: .max, from: mainNode.nodes, player: player, opponent: opponent)
//            
//            guard let point = bestNode.point else {
//                return
//            }
//            
//            DispatchQueue.main.async {
//                completion(point)
//            }
//        }
    }
    
    fileprivate func configureChilds(from node: Node, player: Player, opponent: Player) {
        
        var _board = node.board // gera uma cópia do estado atual
//        let	player = (node.player == player) ? opponent : player; // verifica de quem é a vez de jogar nesse nível
//        let opponent = (node.player == player) ? player : opponent

        for point in _board.emptyPoints() {
            
            let boardCopy = _board
            let childNode = Node(board: boardCopy, player: player)
            childNode.setPoint(point: point)
            node.childs.append(childNode)
            
            guard !childNode.anyVictory(player: player, opponent: opponent) else {
                if childNode.manager.checkVictory(from: childNode.player) && childNode.player.identifier.uppercased() == "O" {
                    childNode.minimax = +1;		// se a próxima jogada é da CPU, retorna valor max
                } else if  childNode.manager.checkVictory(from: opponent) {
                    childNode.minimax = -1;		// caso contrário, retorna valor min
                } else {
                    childNode.minimax = 0
                }
                break
            }
            
            guard !childNode.completed() else {
                if childNode.manager.checkVictory(from: childNode.player) && childNode.player.identifier.uppercased() == "O" {
                    childNode.minimax = +1;		// se a próxima jogada é da CPU, retorna valor max
                } else if  childNode.manager.checkVictory(from: opponent) {
                    childNode.minimax = -1;		// caso contrário, retorna valor min
                } else {
                    childNode.minimax = 0
                }
                break
            }
            
            let	player = (node.player == player) ? opponent : player; // verifica de quem é a vez de jogar nesse nível
            let opponent = (node.player == player) ? player : opponent

            configureChilds(from: childNode, player: player, opponent: opponent)
        }
    }
    
//    fileprivate func configureChildNodes(from node: Node, player: Player, opponent: Player) {
//        
//        var boardCopy = node.board
//        let procedure = node.procedure.toggle()
//        let nextPlayer = procedure == .min ? player : opponent
//
//        for point in boardCopy.emptyPoints() {
//
//            let childNode = Node(procedure: procedure, board: boardCopy, player: nextPlayer)
//            childNode.setStep(point: point, player: nextPlayer)
//            node.nodes.append(childNode)
//            
//            guard !node.anyVictory(player: player, opponent: opponent) else {
//                return
//            }
//            
//            guard !node.completed() else {
//                return
//            }
//            
//            configureChildNodes(from: childNode, player: player, opponent: opponent)
//        }
//    }
    
//    fileprivate func getBestScore(procedure: ProcedureType, from nodes: [Node], player: Player, opponent: Player) -> Node {
//        
//        var best: Node! // node.first!
//        for node in nodes {
//            if best == nil { // first
//                best = node
//            }
//            
//            node.minimax = miniMaxValue(procedure: procedure, from: node.nodes, player: player, opponent: opponent)
//            
//            if procedure == .max, node.minimax > best.minimax {
//                best = node
//            } else if procedure == .min, node.minimax < best.minimax {
//                best = node
//            }
//        }
//        
//        return best
//    }
    
//    fileprivate func miniMaxValue(procedure: ProcedureType, from nodes: [Node], player: Player, opponent: Player) -> Int {
//        
//        var value = 0
//        
//        for node in nodes {
//            if node.nodes.count > 0 {
//                value = miniMaxValue(procedure: procedure.toggle(), from: node.nodes, player: player, opponent: opponent)
//            } else {
//                // TODO: - Refatorar.. juntar if's interno
//                if procedure == .max {
//                    if node.manager.checkVictory(from: player) {
//                        value = 1
//                    }
//                } else if procedure == .min {
//                    if node.manager.checkVictory(from: opponent) {
//                        value = -1
//                    }
//                }
//            }
//        }
//        
//        if value == 0 {
//            print("Deu ruim")
//        }
//        
//        return value
//    }
    
    fileprivate func minimax(node: Node) {	// calcula o valor minimax de um nodo
        var min, max: Int?
        for child in node.childs {	// percorre todos os filhos do nodo
            if (child.minimax == nil) {	// se um filho ainda não tem um valor minimax (não é folha da árvore)
                minimax(node: child) // chama a função recursivamente para aquele filho
            }
            
            if (max == nil || child.minimax! > max!) {	// guarda valor max (maior minimax entre os filhos)
                max = child.minimax!
            }
            if (min == nil || child.minimax! < min!) {	// guarda valor min (menor minimax entre os filhos)
                min = child.minimax!
            }
        }
        if node.player.identifier.uppercased() == "O" {
            node.minimax = max;		// se a próxima jogada é da CPU, retorna valor max
        } else {
            node.minimax = min;		// caso contrário, retorna valor min
        }
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

fileprivate class Node {
    
    // Arvore de Pronfundidade
    // +1 vitória MAX (x)
    // -1 Vitória de MIN (o)
    //  0 Empate
    //  -2 Empty
    
    var minimax: Int?
    
    var player: Player
    
    var childs: [Node] = []

    private(set) var board: Board
    private(set) var point: BoardPoint?
    
    private(set) lazy var manager: GameManager = { return GameManager(board: self.board)}()

    
    // Initializers
    
    init(board: Board, player: Player) {
        self.board = board
        self.player = player
    }
    
    
    // MARK: - Helper
    
    func setPoint(point: BoardPoint) {
        self.board.select(point: point, from: self.player)
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

