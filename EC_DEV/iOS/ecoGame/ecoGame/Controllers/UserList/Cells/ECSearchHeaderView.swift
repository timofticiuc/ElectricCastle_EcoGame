//
//  ECSearchHeaderView.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 14/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

protocol ECSearchDelegate {
    func searchView(searchView: ECSearchHeaderView, didChangeQueryWithText query:String)
}

class ECSearchHeaderView: UIView, UITextFieldDelegate {
    var delegate: ECSearchDelegate?
    @IBOutlet weak var searchFieldWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search for participants", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()	])
    }
    
    @IBAction func searchFieldTextDidChange(sender: UITextField) {
        self.delegate?.searchView(self, didChangeQueryWithText: sender.text!)
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        self.searchFieldWidthConstraint.constant = 0;
        UIView.animateWithDuration(0.25) { 
            self.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.searchFieldWidthConstraint.constant = -300;
        UIView.animateWithDuration(0.25) {
            self.layoutIfNeeded()
        }
    }
}
