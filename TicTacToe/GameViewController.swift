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
    
    
    // MARK: - Actions
    
    @IBAction func resetGame() {
        self.manager.reset()
    }
    
    func showAlert(message: String) {
        UIAlertController.show(title: message, message: "", cancelButtonTitle: "Jogar novamente!") {
            self.resetGame()
        }
    }
    
}


// MARK: - GameManagerDelegate

extension GameBoardViewController: GameManagerDelegate {
    func gameReseted(manager: GameManager) {
        self.collectionView?.reloadData()
    }
    
    func gameManager(_ manager: GameManager, finishedWith result: GameResult) {
        switch result {
        case .tie:
            showAlert(message: "Empate!")
            break
        case .victory(let player):
            showAlert(message: "Vitória de: \(player.identifier)")
            break
        }
    }
    
    func gameManager(_ manager: GameManager, didSelected point: BoardPoint, from player: Player) {
        self.collectionView?.reloadItems(at: [ IndexPath.make(from: point) ])
    }
}


// MARK: - UICollectionViewDataSource

extension GameBoardViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.board.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return manager.board.canSelect(point: BoardPoint.make(from: indexPath) )
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoardCell.defaultReuseIdentifier, for: indexPath) as! BoardCell
        
        let point = BoardPoint.make(from: indexPath)
        cell.imageView?.image =  manager.player(at: point)?.image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let point = BoardPoint.make(from: indexPath)
        
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
        // Paddings - Storyboard
        // 10[----]3[----]3[-----]10
        let width = (UIScreen.main.bounds.width - 26) / CGFloat(Board.sideSize)
        return CGSize(width: width, height: width)
    }
    
}

