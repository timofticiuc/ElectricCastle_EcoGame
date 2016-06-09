//
//  ECCategoryController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 25/05/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit
import QRCodeReader
import AVFoundation

class ECCategoryController: UIViewController, UITableViewDelegate, UITableViewDataSource, ECCategoryActionCellDelegate, ECActionInputDelegate, ECCarbonFootprintDelegate {
    @IBOutlet private weak var tableView:UITableView!
    lazy var readerVC = QRCodeReaderViewController(metadataObjectTypes: [AVMetadataObjectTypeQRCode])

    var category:ECCategory!

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
        cell.actionScore = self.category.categoryScores[indexPath.row]
        cell.delegate = self
        cell.index = indexPath.row
        
        return cell
    }
    
    //MARK: - ECCategoryActionCellDelegate
    
    func actionCell(cell: ECCategoryActionCell, hasChangedScore score: Int) {
        self.saveActionForCell(cell)
    }
    
    private func saveActionForCell(cell: ECCategoryActionCell) {
        self.category.categoryScores[cell.index] = cell.actionScore
        self.category.userLevel = ECConstants.ECCategoryLevel.Beginner
        for i in (0...self.category.actions().count - 1).reverse() {
            if self.category.categoryScores[i] != 0 {
                let level = self.category.actions()[i][kScore]?.intValue
                self.category.userLevel = ECConstants.ECCategoryLevel(rawValue: level!)!
            }
        }
        
        ECCoreManager.sharedInstance.storeManager.saveContext()
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
            
        default:
            return
        }
    }
    
    //MARK: - action methods
    
    func handleQRForCell(cell: ECCategoryActionCell) {
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            cell.actionScore+=1
            self.saveActionForCell(cell)
        }
        
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .FormSheet
        presentViewController(readerVC, animated: true, completion: nil)
    }
    
    func handleCarbonFootprintForCell(cell: ECCategoryActionCell) {
        let carbonVC: ECCarbonFootprintController = ECCarbonFootprintController.ec_createFromStoryboard() as! ECCarbonFootprintController
        carbonVC.delegate = self
        carbonVC.targetActionCell = cell
        
//        carbonVC.modalPresentationStyle = .FormSheet
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
        self.saveActionForCell(ac.targetActionCell)
    }
    
    //MARK: - ECCarbonFootprintDelegate
    
    func carbonFootprintController(cfc: ECCarbonFootprintController, hasInputedValue value: String) {
        if value.characters.count == 0 {
            return
        }
        cfc.targetActionCell.actionScore+=1
        self.saveActionForCell(cfc.targetActionCell)
        cfc.dismissViewControllerAnimated(true, completion: nil)
    }
}
