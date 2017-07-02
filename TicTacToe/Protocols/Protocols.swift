//
//  ReusableView+Protocol.swift
//  BirdLight
//
//  Created by Romilson Nunes on 01/03/16.
//  Copyright © 2016 Romilson Nunes. All rights reserved.
//

import Foundation
import UIKit


// MARK: - ReusableView

protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        // FIXME: - Reveja o unwraping
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UICollectionViewCell: ReusableView {
}

