//
//  ECUserListCell.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 02/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

class ECUserListCell: UITableViewCell {
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userRoleLabel: UILabel!
    @IBOutlet private weak var userEnergyLabel: UILabel!
    @IBOutlet private weak var userWasteLabel: UILabel!
    @IBOutlet private weak var userWaterLabel: UILabel!
    @IBOutlet private weak var userTransportLabel: UILabel!
    @IBOutlet private weak var userSocialLabel: UILabel!
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clearColor()
    }
    
    var user: ECUser! {
        didSet {
            self.userNameLabel.text = user.userFirstName + " " + user.userLastName
            self.userRoleLabel.text = user.userRole.ec_enumName()
            
            if user.userCategories.count < 5 {
                return
            }
            
            self.userEnergyLabel.text = String(self.user.userCategories[0].overallScore())
            self.userWasteLabel.text = String(self.user.userCategories[1].overallScore())
            self.userWaterLabel.text = String(self.user.userCategories[2].overallScore())
            self.userTransportLabel.text = String(self.user.userCategories[3].overallScore())
            self.userSocialLabel.text = String(self.user.userCategories[4].overallScore())
        }
    }
    
}
