//
//  ECUserListDataSource.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 02/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit
import CoreData

protocol ECUserListDataSourceDelegate {
    func dataSource(ds:ECUserListDataSource, wantsToShowViewController vc:UIViewController)
}

class ECUserListDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    private var delegate: ECUserListDataSourceDelegate?
    private var tableView: UITableView!
    private var _frc: NSFetchedResultsController!
    private var frc: NSFetchedResultsController! {
        get {
            if (_frc == nil) && ECCoreManager.sharedInstance.storeManager.managedObjectContext != nil {
                _frc = NSFetchedResultsController(fetchRequest: ECUser.fetchRequestForUsers(),
                                                  managedObjectContext: ECCoreManager.sharedInstance.storeManager.managedObjectContext!,
                                                  sectionNameKeyPath: nil,
                                                  cacheName: nil)
                _frc.delegate = self
            }
            
            return _frc
        }
    }
    
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
        self.frc.ec_performFetch()
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
    }
    
    func addUser() {
        let user:ECUser = ECUser.objectCreatedOrUpdatedWithDictionary(["id":"\((self.frc?.fetchedObjects?.count)! as Int)", "userPhone":"0740811856", "userName":"timo"], inContext:ECCoreManager.sharedInstance.storeManager.managedObjectContext!) as! ECUser
        user.createdAt = NSDate()
        
        ECCoreManager.sharedInstance.storeManager.saveContext()
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.frc!.fetchedObjects!.count;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ECUserListCell = tableView.dequeueReusableCellWithIdentifier(String(ECUserListCell), forIndexPath: indexPath) as! ECUserListCell
        
        cell.user = self.frc.fetchedObjects?[indexPath.row] as! ECUser
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.fetchData()
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
        };
    }
}