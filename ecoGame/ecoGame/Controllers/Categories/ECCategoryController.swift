//
//  ECCategoryController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 25/05/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

class ECCategoryController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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

        if category.userLevel != .Beginner {
            self.tableView.selectRowAtIndexPath(NSIndexPath(forRow:Int(self.category.selectedAction), inSection: 0), animated: true, scrollPosition: .Middle)
        }
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
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.category.selectedAction = Int32(indexPath.row)
        let score = self.category.actions()[indexPath.row][kScore]?.intValue
        self.category.userLevel = ECConstants.ECCategoryLevel(rawValue: score!)!
        
        ECCoreManager.sharedInstance.storeManager.saveContext()
    }
}
