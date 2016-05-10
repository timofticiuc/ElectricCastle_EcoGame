//
//  UIViewController+ECAdditions.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 06/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

extension UIViewController {
    static func ec_createFromStoryboard() -> UIViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(String(self))
    }
}