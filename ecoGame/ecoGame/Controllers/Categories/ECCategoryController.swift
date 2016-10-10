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
    var quizActionCell:ECCategoryActionCell!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.ec_registerCell(ECCategoryActionCell)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleEcoQuizAgreementNotification), name: kAgreementNotification, object: nil)
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
        cell.scoreMultiplier = self.category.actions()[indexPath.row][kMultiplier]!.integerValue
        cell.actionScore = self.category.categoryScores[indexPath.row].score
        cell.delegate = self
        cell.index = indexPath.row
        
        switch self.category.categoryType {
        case .Energy:
            if indexPath.row == 0 {
                let metaData = self.category.categoryScores[indexPath.row].metadata
                if metaData.characters.count != 0 {
                    cell.actionTitleLabel.text! += " (" + metaData + ")"
                }
            } else if indexPath.row == 1 {
                let metaData = self.category.categoryScores[indexPath.row].metadata
                if metaData.characters.count != 0 {
                    cell.actionTitleLabel.text! += " (" + metaData + ")"
                }
            }
            break
        case .Transport:
            if indexPath.row < self.category.categoryScores.count - 1 {
                let metaData = self.category.categoryScores[indexPath.row].metadata
                if metaData.characters.count != 0 {
                    cell.actionTitleLabel.text! += " (" + metaData + " km)"
                }
            }
            break
        
        default:
            break
        }
        
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
        
        self.category.dirty = true
        ECCoreManager.sharedInstance.storeManager.saveContext()
        
        if !self.user.id.hasPrefix("temp_") {
            ECCoreManager.sharedInstance.updateCategory(self.category)
            self.user.dirty = true
            ECCoreManager.sharedInstance.updateUser(self.user)
        }
        
        self.tableView.reloadData()
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
                self.handleEcoQuizForCell(cell)
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
        
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
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
    
    func handleEcoQuizForCell(cell: ECCategoryActionCell) {
        do {
            var dict = self.user.dictionaryRepresentation!
            dict.removeValueForKey("user_updated_timestamp")
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions(rawValue: 0))
            let userDictString = jsonData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            let url  = NSURL(string: "ecoQuiz://user?userdict="+userDictString)
            self.quizActionCell = cell
            UIApplication.sharedApplication().openURL(url!)
        } catch {
        }
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
    
    //MARK: - EcoQuiz notification
    
    func handleEcoQuizAgreementNotification(notification: NSNotification) {
        let agreed = notification.object as! Bool
        
        if agreed && (self.quizActionCell != nil) {
            self.quizActionCell.actionScore += 1
            self.saveActionForCell(self.quizActionCell)
        }
    }
}
