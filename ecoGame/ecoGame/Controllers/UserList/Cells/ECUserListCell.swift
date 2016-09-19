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
        }
    }
    
    func displayScores() {
        if user.userCategories.count < 5 {
            return
        }
        
        weak var weakSelf: ECUserListCell? = self
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let categs = self.user.userCategories
            var scoreStrings = [String]()
            var titleStrings = [String]()
            
            for index in 1...5 {

                let categString = categs[index - 1].categoryName
                let scoreString = "Score: " + String(categs[index - 1].overallScore())
                let actions = "/" + String(categs[index - 1].actions().count)
                let titleString = categString + " " + String(categs[index - 1].scoreCompleteness()) + actions
                scoreStrings.append(scoreString)
                titleStrings.append(titleString)
                
                if titleStrings.count == 5 {
                    dispatch_async(dispatch_get_main_queue()) {
                        for index in 1...5 {
                            if weakSelf == nil {
                                return
                            }
                            
                            let label = weakSelf?.viewWithTag(index * 10) as! UILabel
                            let titleLabel = weakSelf?.viewWithTag(index) as! UILabel
                            
                            label.text = scoreStrings[index - 1]
                            titleLabel.text = titleStrings[index - 1]
                        }
                    }
                }
            }
        }
    }
}
