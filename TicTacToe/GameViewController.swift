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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


// MARK: - UICollectionViewDataSource

extension GameBoardViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoardCell.defaultReuseIdentifier, for: indexPath) as! BoardCell
        
        return cell
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

