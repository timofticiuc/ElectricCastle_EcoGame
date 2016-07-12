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
    @IBOutlet private weak var userEnergyTitleLabel: UILabel!
    @IBOutlet private weak var userWasteTitleLabel: UILabel!
    @IBOutlet private weak var userWaterTitleLabel: UILabel!
    @IBOutlet private weak var userTransportTitleLabel: UILabel!
    @IBOutlet private weak var userSocialTitleLabel: UILabel!
    
    var index : Int = 0
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clearColor()
    }
    
    var user: ECUser! {
        didSet {
            self.userNameLabel.text = String(self.index) + ". " + user.userFirstName + " " + user.userLastName
            self.userRoleLabel.text = user.userRole.ec_enumName()
            
            if user.userCategories.count < 5 {
                return
            }
            
            self.userEnergyLabel.text = "Score: " + String(self.user.userCategories[0].overallScore())
            self.userWasteLabel.text = "Score: " + String(self.user.userCategories[1].overallScore())
            self.userWaterLabel.text = "Score: " + String(self.user.userCategories[2].overallScore())
            self.userTransportLabel.text = "Score: " + String(self.user.userCategories[3].overallScore())
            self.userSocialLabel.text = "Score: " + String(self.user.userCategories[4].overallScore())
            
            self.userEnergyTitleLabel.text = "Energy " + String(self.user.userCategories[0].scoreCompleteness()) + "/" + String(self.user.userCategories[0].actions().count)
            self.userWasteTitleLabel.text = "Waste " + String(self.user.userCategories[1].scoreCompleteness()) + "/" + String(self.user.userCategories[1].actions().count)
            self.userWaterTitleLabel.text = "Water " + String(self.user.userCategories[2].scoreCompleteness()) + "/" + String(self.user.userCategories[2].actions().count)
            self.userTransportTitleLabel.text = "Transport " + String(self.user.userCategories[3].scoreCompleteness()) + "/" + String(self.user.userCategories[3].actions().count)
            self.userSocialTitleLabel.text = "Social " + String(self.user.userCategories[4].scoreCompleteness()) + "/" + String(self.user.userCategories[4].actions().count)
        }
    }
    
}
