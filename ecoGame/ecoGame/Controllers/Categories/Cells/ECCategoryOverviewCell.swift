//
//  ECCategoryCell.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 02/05/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit
import KDCircularProgress

class ECCategoryOverviewCell: UICollectionViewCell {
    @IBOutlet private weak var categoryTitleLabel: UILabel!
    @IBOutlet private weak var categoryLevelLabel: UILabel!
    @IBOutlet private weak var categoryProgressContainerView: UIView!
    @IBOutlet private weak var categoryImageView: UIImageView!

    private var progressView: KDCircularProgress! = nil
    
    var category:ECCategory! {
        didSet {
            switch category.categoryType {
            case .Energy:
                self.categoryImageView.image = UIImage(named: "Energy")
                break
            case .Water:
                self.categoryImageView.image = UIImage(named: "Water")
                break;
            case .Transport:
                self.categoryImageView.image = UIImage(named: "Transport")
                break
            case .Social:
                self.categoryImageView.image = UIImage(named: "Social")
                break
            case .Waste:
                self.categoryImageView.image = UIImage(named: "Waste")
                break
            default:
                break
            }
        
            self.categoryTitleLabel.text = category.categoryName
        }
    }
    
    var categoryLevel:ECConstants.ECCategoryLevel? = nil {
        didSet {
            var level:Double = 0
            switch categoryLevel! {
            case .Legend:
                level = 360
                break
            case .Angel:
                level = 240
                break
            case .Guardian:
                level = 120
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
        
        progressView = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: self.categoryProgressContainerView.frame.size.width, height: self.categoryProgressContainerView.frame.size.height))
        progressView.startAngle = -90
        progressView.clockwise = true
        progressView.center = self.categoryProgressContainerView.center
        progressView.gradientRotateSpeed = 2
        progressView.roundedCorners = true
        progressView.glowMode = .Forward
        progressView.setColors(UIColor.ec_green())
        progressView.trackColor = UIColor ( red: 0.8588, green: 0.8588, blue: 0.8588, alpha: 1.0 )
        progressView.trackThickness = 0.2
        progressView.progressThickness = 0.2
        self.categoryProgressContainerView.ec_addSubView(progressView, withInsets: UIEdgeInsetsZero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressView.frame = CGRectMake(0,
                                        0,
                                        self.categoryProgressContainerView.frame.size.width,
                                        self.categoryProgressContainerView.frame.size.height)
        progressView.center = self.categoryProgressContainerView.center
    }
}
