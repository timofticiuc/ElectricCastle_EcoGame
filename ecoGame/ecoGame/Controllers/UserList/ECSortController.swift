//
//  ECSortController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 01/07/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

protocol ECSortDelegate {
    func sortController(sc: ECSortController, hasSelectedCategory category:ECConstants.Category, withSortAsAscending ascending: Bool, actionIndex: Int)
}

class ECSortController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var delegate: ECSortDelegate?
    @IBOutlet private weak var pickerView: UIPickerView!
    @IBOutlet weak var categorySegmentControl: UISegmentedControl!
    private var category: ECConstants.Category = .Energy

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.categorySegmentControl.addTarget(self, action: #selector(categoryChanged), forControlEvents: .ValueChanged)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func categoryChanged(segmentControl: UISegmentedControl) {
        self.category = ECConstants.Category(rawValue: Int32(segmentControl.selectedSegmentIndex))!
        self.pickerView.reloadAllComponents()
    }

    //MARK: - UIPickerViewDataSource & UIPickerViewDelegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return ECCategory.defaultActionsForCategory(self.category).count + 1
        }
        
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var titleString = ""
        if component == 0 {
            if row == 0 {
                titleString = "overall score"
            } else {
                titleString = ECCategory.defaultActionsForCategory(self.category)[row - 1][kTitle] as! String
            }
        } else if component == 1 {
            switch row {
            case 0:
                titleString = "descending"
                break
            case 1:
                titleString = "ascending"
                break
            default:
                break
            }
        }
        
        return NSAttributedString(string: titleString, attributes: [NSForegroundColorAttributeName : UIColor.ec_green()])
    }
    
    //MARK: - Actions
    
    @IBAction func doneAction() {
        var selectedAction = self.pickerView.selectedRowInComponent(0)
        let ascending = Bool(self.pickerView.selectedRowInComponent(1))
        
        if selectedAction == 0 {
            selectedAction = -1
        } else {
            selectedAction -= 1
        }
        
        self.delegate?.sortController(self, hasSelectedCategory: self.category, withSortAsAscending: ascending, actionIndex: selectedAction)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
