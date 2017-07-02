//
//  BoardCell.swift
//  TicTacToe
//
//  Created by Romilson Nunes on 02/07/17.
//  Copyright © 2017 Romilson Nunes. All rights reserved.
//

import UIKit

class BoardCell: UICollectionViewCell {
 
    @IBOutlet weak var imageView: UIImageView?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView?.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()
    }
}
