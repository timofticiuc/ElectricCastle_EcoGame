//
//  ECCategoryController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 25/05/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

class ECCategoryController: UIViewController, UITableViewDelegate, UITableViewDataSource, ECCategoryActionCellDelegate, ECActionInputDelegate, ECCarbonFootprintDelegate, ECQRDelegate {
    @IBOutlet private weak var tableView:UITableView!

    var category:ECCategory!
    var user:ECUser!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.ec_registerCell(ECCategoryActionCell)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = self.category.categoryName
        self.tableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.category.actions().count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ECCategoryActionCell = tableView.dequeueReusableCellWithIdentifier(String(ECCategoryActionCell), forIndexPath: indexPath) as! ECCategoryActionCell
        
        cell.actionDictionary = self.category.actions()[indexPath.row]
        cell.scoreMultiplier = self.category.actions().count - indexPath.row
        cell.actionScore = self.category.categoryScores[indexPath.row].score
        cell.delegate = self
        cell.index = indexPath.row
        
        return cell
    }
    
    //MARK: - ECCategoryActionCellDelegate
    
    private func saveActionForCell(cell: ECCategoryActionCell) {
        self.saveActionForCell(cell, withMetadata: "")
    }
    
    private func saveActionForCell(cell: ECCategoryActionCell, withMetadata metadata: String) {
        var _scores = self.category.categoryScores
        _scores[cell.index].score = cell.actionScore
        _scores[cell.index].metadata = metadata
        self.category.categoryScores = _scores
        self.category.userLevel = ECConstants.ECCategoryLevel.Beginner
        for i in (0...self.category.actions().count - 1).reverse() {
            if self.category.categoryScores[i].score != 0 {
                let level = self.category.actions()[i][kScore]?.intValue
                self.category.userLevel = ECConstants.ECCategoryLevel(rawValue: level!)!
            }
        }
        
        ECCoreManager.sharedInstance.storeManager.saveContext()
        ECCoreManager.sharedInstance.updateCategory(self.category)
    }
    
    func actionCell(cell: ECCategoryActionCell, hasChangedScore score: Int) {
        self.saveActionForCell(cell)
    }
    
    func actionCell(cell: ECCategoryActionCell, requestsActionForIndex index: Int) {
        switch self.category.categoryType {
        case .Energy:
            switch index {
            case 0:
                self.handleQRForCell(cell)
                break
            case 1:
                self.handleCarbonFootprintForCell(cell)
                break
            default:
                return
            }
            break
            
        case .Transport:
            switch index {
            case 1...3:
                self.handleDistanceForCell(cell)
                break
            default:
                return
            }
            break
            
        case .Social:
            switch index {
            case 2:
                break
            default:
                return
            }
            break
            
        default:
            return
        }
    }
    
    //MARK: - action methods
    
    func handleQRForCell(cell: ECCategoryActionCell) {
        let qrVC: ECQRController = ECQRController.ec_createFromStoryboard() as! ECQRController
        qrVC.qrDict = ["id":self.user.id,
                       "name":self.user.userFirstName]
        qrVC.delegate = self
        qrVC.targetActionCell = cell
        
        qrVC.modalPresentationStyle = .FormSheet
        self.presentViewController(qrVC, animated: true, completion: nil)
    }
    
    func handleCarbonFootprintForCell(cell: ECCategoryActionCell) {
        let carbonVC: ECCarbonFootprintController = ECCarbonFootprintController.ec_createFromStoryboard() as! ECCarbonFootprintController
        carbonVC.delegate = self
        carbonVC.targetActionCell = cell
        
        self.presentViewController(carbonVC, animated: true, completion: nil)
    }
    
    func handleDistanceForCell(cell: ECCategoryActionCell) {
        let actionVC: ECActionInputController = ECActionInputController.ec_createFromStoryboard() as! ECActionInputController
        actionVC.delegate = self
        actionVC.targetActionCell = cell
        
        actionVC.modalPresentationStyle = .FormSheet
        self.presentViewController(actionVC, animated: true, completion: nil)
    }
    
    //MARK: - ECActionInputDelegate
    
    func actionController(ac: ECActionInputController, hasInputedValue value: String) {
        if value.characters.count == 0 {
            return
        }
        ac.targetActionCell.actionScore+=1
        self.saveActionForCell(ac.targetActionCell, withMetadata:value)
    }
    
    //MARK: - ECCarbonFootprintDelegate
    
    func carbonFootprintController(cfc: ECCarbonFootprintController, hasInputedValue value: String) {
        if value.characters.count == 0 {
            return
        }
        cfc.targetActionCell.actionScore+=1
        self.saveActionForCell(cfc.targetActionCell, withMetadata:value)
        cfc.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - ECQRDelegate
    
    func qrController(qrc: ECQRController, hasScannedWithValue value: String) {
        if value.characters.count == 0 {
            return
        }
        
        qrc.targetActionCell.actionScore+=1
        self.saveActionForCell(qrc.targetActionCell, withMetadata:value)
        qrc.dismissViewControllerAnimated(true, completion: nil)
    }
}
