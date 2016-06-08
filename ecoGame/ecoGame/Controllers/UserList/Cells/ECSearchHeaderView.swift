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
    @IBOutlet weak var searchTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search for participants", attributes: [NSForegroundColorAttributeName : UIColor ( red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0 )	])
    }
    
    @IBAction func searchFieldTextDidChange(sender: UITextField) {
        self.delegate?.searchView(self, didChangeQueryWithText: sender.text!)
    }
}
