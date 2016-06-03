//
//  ECCategoryController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 25/05/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

class ECCategoryController: UIViewController, UITableViewDelegate, UITableViewDataSource, ECCategoryActionCellDelegate {
    @IBOutlet private weak var tableView:UITableView!
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
        self.category.categoryScores[cell.index] = cell.actionScore
        for i in (0...self.category.actions().count - 1).reverse() {
            if self.category.categoryScores[i] != 0 {
                let level = self.category.actions()[i][kScore]?.intValue
                self.category.userLevel = ECConstants.ECCategoryLevel(rawValue: level!)!
            }
        }
        
        ECCoreManager.sharedInstance.storeManager.saveContext()
    }
}
