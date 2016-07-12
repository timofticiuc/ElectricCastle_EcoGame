//
//  ECSortController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 01/07/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

protocol ECSortDelegate {
    func sortController(sc: ECSortController, hasSelectedCategory category:ECConstants.Category, withSortAsAscending ascending: Bool)
}

class ECSortController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var delegate: ECSortDelegate?
    @IBOutlet private weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - UIPickerViewDataSource & UIPickerViewDelegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return Int(ECConstants.Category.Count.rawValue)
        }
        
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var titleString = ""
        if component == 0 {
            let categ = ECConstants.Category(rawValue: Int32(row))
            titleString = (categ?.ec_enumName())!
        } else if component == 1 {
            switch row {
            case 0:
                titleString = "ascending"
                break
            case 1:
                titleString = "descending"
                break
            default:
                break
            }
        }
        
        return NSAttributedString(string: titleString, attributes: [NSForegroundColorAttributeName : UIColor.ec_green()])
    }
    
    //MARK: - Actions
    
    @IBAction func doneAction() {
        let selectedCateg = self.pickerView.selectedRowInComponent(0)
        let ascending = Bool(self.pickerView.selectedRowInComponent(1))
        self.delegate?.sortController(self, hasSelectedCategory: ECConstants.Category(rawValue:Int32(selectedCateg))! , withSortAsAscending: ascending)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelAction() {
        self.delegate?.sortController(self, hasSelectedCategory: ECConstants.Category.None , withSortAsAscending: false)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
