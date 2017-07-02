//
//  Extensions.swift
//  TicTacToe
//
//  Created by Romilson Nunes on 02/07/17.
//  Copyright © 2017 Romilson Nunes. All rights reserved.
//

import UIKit


// MARK: - IndexPath

extension IndexPath {
    
    static func make(from point: BoardPoint) -> IndexPath {
        let row = (point.row + 1)
        let column = (point.column + 1)
        
        let index = ((row * 3) - (3 - column)) - 1
        return IndexPath(item: index, section: 0)
    }
}


// MARK: - BoardPoint

extension BoardPoint {
    
    static func make(from indexPath: IndexPath) -> BoardPoint {
        let index = Float(indexPath.item + 1)
        var row = Float( UInt( Float(index) / 3.0 ) )
        if index.truncatingRemainder(dividingBy: 3) == 0.0 { // x % y -> remaning
            row -= 1
        }
        let column =  UInt( ((index - (row * 3)) - 1) )
        
        return BoardPoint(column: Int(column), row: Int(row))
    }
}

// MARK: - UIWindow

public extension UIWindow {
    
    func topViewController() -> UIViewController? {
        
        var topController = self.rootViewController //[UIApplication sharedApplication].keyWindow.rootViewController;
        
        while let viewController = topController?.presentedViewController {
            topController = viewController
        }
        return topController;
    }
}


// MARK: - Alert

extension UIAlertController {
    
    func show() {
        if let topViewController = UIApplication.shared.keyWindow?.topViewController() {
            topViewController.present(self, animated: true, completion: nil)
        }
    }
    
    @discardableResult
    static func show(title: String, message: String, cancelButtonTitle: String, confirmationButtonTitle: String? = nil, dissmissBlock: (()-> Void)? = nil , cancelBlock: (()-> Void)? = nil) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // Cancel Button
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
            cancelBlock?()
        }))
        // Confirmation button
        if let title = confirmationButtonTitle {
            alert.addAction(UIAlertAction(title: title, style: UIAlertActionStyle.default, handler: { (action) -> Void in
                dissmissBlock?()
            }))
        }
        
        alert.show()
        
        return alert
    }
}
