//
//  ViewController.swift
//  TicTacToe
//
//  Created by Romilson Nunes on 02/07/17.
//  Copyright © 2017 Romilson Nunes. All rights reserved.
//

import UIKit

class GameBoardViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView?
    
  var manager: GameManager = GameManager()
    
    let human = Player(identifier: "X", image: #imageLiteral(resourceName: "x"))
    let machine = Player(identifier: "O", image: #imageLiteral(resourceName: "o"))
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - 

extension GameBoardViewController: GameManagerDelegate {
    func gameReseted(manager: GameManager) {
        self.collectionView?.reloadData()
    }
    
    func gameManager(_ manager: GameManager, finishedWith result: GameResult) {
        switch result {
        case .tie:
            print("Empatou")
            break
        case .victory(let player):
            print("vitoria de: \(player.identifier)")
            break
        }
    }
    
    func gameManager(_ manager: GameManager, didSelected point: BoardPoint, from player: Player) {
        self.collectionView?.reloadItems(at: [indexPath(at: point)])
    }
    
    func point(at indexPath: IndexPath) -> BoardPoint {
        let index = Float(indexPath.item + 1)
        var row = Float( UInt( Float(index) / 3.0 ) )
        if index.truncatingRemainder(dividingBy: 3) == 0.0 { // x % y -> remaning
            row -= 1
        }
        let column =  UInt( ((index - (row * 3)) - 1) )
        
        return BoardPoint(column: Int(column), row: Int(row))
    }
    
    func indexPath(at point: BoardPoint) -> IndexPath {
        let row = (point.row + 1)
        let column = (point.column + 1)
        
        let index = ((row * 3) - (3 - column)) - 1
        return IndexPath(item: index, section: 0)
    }

}


// MARK: - UICollectionViewDataSource

extension GameBoardViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
   /* func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        <#code#>
    }
    */
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoardCell.defaultReuseIdentifier, for: indexPath) as! BoardCell
      
        let point = self.point(at: indexPath)
        
        // TODO: - change to manger.player(from: point)
        cell.imageView?.image =  manager.board[point]?.image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let point = self.point(at: indexPath)

        guard let lastPlayer = manager.lastPlayer else {
            return manager.select(point: point, from: human)
        }
        let currentPlayer = lastPlayer == human ? machine : human
        manager.select(point: point, from: currentPlayer)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension GameBoardViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Paddings
        // 10----3----3-----10
        let width = (UIScreen.main.bounds.width - 26) / 3
        return CGSize(width: width, height: width)
    }

}

