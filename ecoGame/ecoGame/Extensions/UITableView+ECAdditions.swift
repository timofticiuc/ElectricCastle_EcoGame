//
//  UITableView+ECAdditions.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 03/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

extension UITableView {
    
    func ec_registerCell(forClass: AnyClass) {
        self.registerNib(UINib(nibName: String(forClass), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(forClass))
    }
    
}