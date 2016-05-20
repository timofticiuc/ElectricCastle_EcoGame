//
//  ECCategoryCell.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 02/05/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit
import KDCircularProgress

class ECCategoryCell: UICollectionViewCell {
    @IBOutlet private weak var categoryTitleLabel: UILabel!
    @IBOutlet private weak var categoryLevelLabel: UILabel!
    private var progressView: KDCircularProgress! = nil
    
    var category:ECCategory! {
        didSet {
            var gradientColor:UIColor = UIColor.clearColor()
            let alpha:CGFloat = 0.7
            switch category.categoryType {
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
            
            self.progressView.setColors(UIColor.whiteColor(), gradientColor)
            self.layer.borderColor = gradientColor.CGColor
            self.layer.borderWidth = 3.0
            self.categoryTitleLabel.text = category.categoryName
        }
    }
    
    var categoryLevel:ECConstants.ECCategoryLevel? = nil {
        didSet {
            var level:Double = 0
            switch categoryLevel! {
            case .Angel:
                level = 120
                break
            case .Legend:
                level = 240
                break
            case .Guardian:
                level = 360
                break
            default:
                level = 0
                break
            }
            
            self.progressView.animateToAngle(level, duration: 1.25, completion: nil)
            self.categoryLevelLabel.text = categoryLevel?.ec_enumName()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.masksToBounds = true
        
        progressView = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        progressView.startAngle = -90
        progressView.progressThickness = 0.2
        progressView.trackThickness = 0.7
        progressView.clockwise = true
        progressView.center = self.center
        progressView.gradientRotateSpeed = 2
        progressView.roundedCorners = true
        progressView.glowMode = .Forward
        progressView.trackColor = UIColor.clearColor()
        self.ec_addSubView(progressView, withInsets: UIEdgeInsetsZero)
        self.sendSubviewToBack(progressView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.size.width/2
        progressView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
    }
}
