//
//  UIVIew+ECAdditions.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 14/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

extension UIView {
    public class func loadFromNib<T: UIView>(viewType: T.Type) -> T {
        return NSBundle.mainBundle().loadNibNamed(String(viewType), owner: nil, options: nil).first as! T
    }
    
    public class func ec_loadFromNib() -> Self {
        return loadFromNib(self)
    }
    
    public func ec_addSubView(subview: UIView, withInsets insets: UIEdgeInsets) {
        self.addSubview(subview)
        
        self.ec_addConstraint(.Top, inRelationToView: subview, withConstant: insets.top)
        self.ec_addConstraint(.Bottom, inRelationToView: subview, withConstant: insets.bottom)
        self.ec_addConstraint(.Left, inRelationToView: subview, withConstant: insets.left)
        self.ec_addConstraint(.Right, inRelationToView: subview, withConstant: insets.right)

        self.setNeedsLayout()
    }
    
    private func ec_addConstraint(attribute: NSLayoutAttribute, inRelationToView view:UIView, withConstant constant:CGFloat) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = NSLayoutConstraint(item: self,
                                                                attribute: attribute,
                                                                relatedBy: .Equal,
                                                                toItem: view,
                                                                attribute: attribute,
                                                                multiplier: 1.0,
                                                                constant: constant)
        self.addConstraint(constraint)
        
        return constraint
    }
}
