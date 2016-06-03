//
//  ECCategoryActionCell.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 25/05/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

protocol ECCategoryActionCellDelegate {
    func actionCell(cell: ECCategoryActionCell, hasChangedScore score: Int)
}

class ECCategoryActionCell: UITableViewCell {
    @IBOutlet private weak var actionTitleLabel:UILabel!
    @IBOutlet private weak var actionDescriptionLabel:UILabel!
    @IBOutlet private weak var actionScoreLabel:UILabel!
    var delegate:ECCategoryActionCellDelegate? = nil
    var scoreMultiplier:Int = 0
    var index:Int = 0
    var actionScore:Int = 0 {
        didSet {
            self.actionScoreLabel.text = String(actionScore * scoreMultiplier)
        }
    }
    
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
    }
    
    @IBAction func didTapPlusButton() {
        self.actionScore += 1
        self.delegate?.actionCell(self, hasChangedScore: self.actionScore * scoreMultiplier)
    }
    
    @IBAction func didTapMinusButton() {
        if self.actionScore > 0 {
            self.actionScore -= 1
            self.delegate?.actionCell(self, hasChangedScore: self.actionScore)
        }
    }
}
