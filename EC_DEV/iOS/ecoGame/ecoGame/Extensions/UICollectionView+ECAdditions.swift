//
//  UICollectionView+ECAdditions.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 02/05/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

extension UICollectionView {
    func ec_registerCell(forClass: AnyClass) {
        self.registerClass(forClass, forCellWithReuseIdentifier: String(forClass))
        self.registerNib(UINib(nibName: String(forClass), bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: String(forClass))
    }
}