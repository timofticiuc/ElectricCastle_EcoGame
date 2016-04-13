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
    @IBOutlet var searchFieldWidthConstraint: NSLayoutConstraint!
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.delegate?.searchView(self, didChangeQueryWithText: searchBar.text!)
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
