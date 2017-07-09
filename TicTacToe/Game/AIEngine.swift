//
//  AIEnginer.swift
//  TicTacToe
//
//  Created by Romilson Nunes on 02/07/17.
//  Copyright © 2017 Romilson Nunes. All rights reserved.
//

import Foundation


class AIEngine {
    
    func predictNextPosition(forPlayer player: Player, inBoard board: Board, withOpponent opponent: Player,completion : @escaping ( BoardPoint ) -> Void ) {
        
        DispatchQueue.global(qos: .background).async {
            let mainNode = Node(board: board, player: player)
            
            // Configure nodes
            self.configureChilds(from: mainNode, player: player, opponent: opponent)
            
            
            var max: Int?
            var options: [Node] = [];	// array das opções de jogadas
            
            // avalia qual a melhor opção de jogada, dentre as possíveis (filhos do estado atual)
            for node in mainNode.childs {
                self.minimax(node: node)
                if let nodeMinimax = node.minimax, (max == nil || nodeMinimax > max!)  {
                    max = node.minimax! // salva maior valor minimax dos filhos
                }
            }
            
            // percorre novamente os filhos, checando todos que tenham o mesmo valor minimax ótimo
            for node in mainNode.childs {
                if (node.minimax == max) {
                    options.append(node) // coloca índice deste filho no array de opções de jogada
                }
            }
            
            let sorted = mainNode.childs.sorted(by: { (node1, node2) -> Bool in
                return node1.depth < node2.depth
            })
            
            // e escolhe aleatoriamente um deles, para dar mais variedade às jogadas
            let randomIndex = Int(arc4random_uniform(UInt32(options.count)))
            guard let point = sorted.first?.point /*options[randomIndex].point*/ else {
                return
            }
            
            DispatchQueue.main.async {
                completion(point)
            }
            
        }
    }
    
    fileprivate func configureChilds(from node: Node, player: Player, opponent: Player) {
        
        var _board = node.board // gera uma cópia do estado atual

        for point in _board.emptyPoints() {
            
            let boardCopy = _board
            let childNode = Node(board: boardCopy, player: player)
            childNode.setPoint(point: point)
            node.childs.append(childNode)
            
            guard !childNode.anyVictory(player: player, opponent: opponent) else {
                setMinimax(to: childNode, opponent: opponent)
                break
            }
            
            guard !childNode.completed() else {
                setMinimax(to: childNode, opponent: opponent)
                break
            }
            
            let	nextPlayer = (node.player == player) ? opponent : player // verifica de quem é a vez de jogar nesse nível
            let nextOpponent = (node.player == player) ? player : opponent

            configureChilds(from: childNode, player: nextPlayer, opponent: nextOpponent)
        }
    }

    fileprivate func setMinimax(to node: Node, opponent: Player) {
        if node.manager.checkVictory(from: node.player) && node.player.identifier.uppercased() == "O" {
            node.minimax = 1;		// se a próxima jogada é da CPU, retorna valor max
        } else if  node.manager.checkVictory(from: opponent) {
            node.minimax = -1;		// caso contrário, retorna valor min
        } else {
            node.minimax = 0
        }
        node.depth = 1
    }
    
    fileprivate func minimax(node: Node) {	// calcula o valor minimax de um nodo
        var min, max: Int?
        var depth: Int = 1
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
            depth = child.depth
        }
        
        if node.player.identifier.uppercased() == "O" {
            node.minimax = max;		// se a próxima jogada é da CPU, retorna valor max
        } else {
            node.minimax = min;		// caso contrário, retorna valor min
        }
        node.depth = depth + 1
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
    
    var depth: Int = 0
    
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

