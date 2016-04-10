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
        return UIColor.init(colorLiteralRed: 88/255.0, green: 198/255.0, blue: 6/255.0, alpha: 1.0)
    }
    
    static func ec_greenFaded() -> UIColor {
        return UIColor.init(colorLiteralRed: 88/255.0, green: 198/255.0, blue: 6/255.0, alpha: 0.5)
    }
    
    static func ec_gray() -> UIColor {
        return UIColor.init(colorLiteralRed: 38/255.0, green: 38/255.0, blue: 38/255.0, alpha: 1.0)
    }
}
