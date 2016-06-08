//
//  UIColor+ECAdditions.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 10/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

extension UIColor {
    static func ec_green() -> UIColor {
        return UIColor ( red: 0.3529, green: 0.7333, blue: 0.0196, alpha: 1.0 )
    }
    
    static func ec_greenFaded() -> UIColor {
        return UIColor.init(colorLiteralRed: 88/255.0, green: 198/255.0, blue: 6/255.0, alpha: 0.5)
    }
    
    static func ec_greenNavBar() -> UIColor {
        return UIColor ( red: 0.1098, green: 0.1098, blue: 0.1098, alpha: 1.0 )
    }
    
    static func ec_gray() -> UIColor {
        return UIColor ( red: 0.149, green: 0.149, blue: 0.149, alpha: 1.0 )
    }
}
