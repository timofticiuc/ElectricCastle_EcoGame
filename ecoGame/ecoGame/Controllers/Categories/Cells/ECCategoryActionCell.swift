//
//  ECCategoryActionCell.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 25/05/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

class ECCategoryActionCell: UITableViewCell {
    @IBOutlet private weak var actionTitleLabel:UILabel!
    @IBOutlet private weak var actionDescriptionLabel:UILabel!
    @IBOutlet private weak var actionCheckImageView:UIImageView!
    
    var actionDictionary:Dictionary<String, AnyObject>! {
        didSet {
            self.actionTitleLabel.text = actionDictionary[kTitle] as? String
            self.actionDescriptionLabel.text = actionDictionary[kDescription] as? String
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.actionCheckImageView.hidden = !selected
    }
    
}
