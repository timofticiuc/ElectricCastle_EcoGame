//
//  ECUserListDataSource.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 02/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit


protocol ECUserListDataSourceDelegate {
    func dataSource(ds:ECUserListDataSource, wantsToShowViewController vc:UIViewController)
}

class ECUserListDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var delegate: ECUserListDataSourceDelegate?
    private var tableView: UITableView?
    private var users = [ECUser]()
    
    convenience init(withDelegate delegate:ECUserListDataSourceDelegate, andTableView tableView:UITableView) {
        self.init()
        
        self.delegate = delegate
        self.tableView = tableView
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.registerRequiredCells()
    }
    
    func registerRequiredCells() {
        self.tableView?.ec_registerCell(ECUserListCell);
    }
    
    func fetchData() {
        // fetch data
        
        self.tableView?.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
    }
    
    func addUser() {
        self.users.append(ECUser.objectCreatedOrUpdatedWithDictionary(["id":"0", "userPhone":"0740811856", "userName":"timo"], inContext: ECCoreManager.sharedInstance.storeManager.managedObjectContext!) as! ECUser)
        ECCoreManager.sharedInstance.storeManager.saveContext()
        self.tableView?.insertRowsAtIndexPaths([NSIndexPath(forRow: self.users.count - 1, inSection: 0)], withRowAnimation: .Automatic)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ECUserListCell = tableView.dequeueReusableCellWithIdentifier(String(ECUserListCell), forIndexPath: indexPath) as! ECUserListCell
        
        cell.user = self.users[indexPath.row]
        
        return cell
    }
    
}