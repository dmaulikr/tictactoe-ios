//
//  Player.swift
//  TicTacToe
//
//  Created by Romilson Nunes on 02/07/17.
//  Copyright © 2017 Romilson Nunes. All rights reserved.
//

import UIKit

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
    
    static func !=(lhs: Player, rhs: Player) -> Bool {
        return !(lhs == rhs)
    }
    
    
}
