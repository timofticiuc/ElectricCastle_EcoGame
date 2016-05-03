//
//  ECCategoryCell.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 02/05/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

class ECCategoryCell: UICollectionViewCell {
    @IBOutlet private weak var categoryTitleLabel: UILabel!
    var category:ECConstants.Category? = nil {
        didSet {
            var gradientColor:UIColor = UIColor.clearColor()
            let alpha:CGFloat = 0.7
            switch category! {
            case .Energy:
                gradientColor = UIColor ( red: 0.5725, green: 0.8157, blue: 0.3137, alpha: alpha )
                break
            case .Water:
                gradientColor = UIColor ( red: 0.2667, green: 0.4471, blue: 0.7686, alpha: alpha )
                break;
            case .Transport:
                gradientColor = UIColor ( red: 1.0, green: 1.0, blue: 0.0, alpha: alpha )
                break
            case .Social:
                gradientColor = UIColor ( red: 1.0, green: 0.7529, blue: 0.0, alpha: alpha )
                break
            case .Waste:
                gradientColor = UIColor ( red: 0.3546, green: 1.0, blue: 0.9992, alpha: alpha )
                break
            default:
                break
            }
            
            self.ec_applyGradientWithColor(UIColor.ec_greenNavBar(), andBottomColor: gradientColor)
            self.categoryTitleLabel.text = category?.ec_enumName()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
    }

}
