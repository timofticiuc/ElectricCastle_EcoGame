//
//  ECUserListCell.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 02/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

class ECUserListCell: UITableViewCell {

    @IBOutlet var userNameLabel: UILabel?
    @IBOutlet var userRoleLabel: UILabel?
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clearColor()
    }
    
    var user: ECUser? {
        didSet {
            self.userNameLabel?.text = user?.userName
            self.userRoleLabel?.text = user?.userRole.ec_enumName()
        }
    }
    
}
