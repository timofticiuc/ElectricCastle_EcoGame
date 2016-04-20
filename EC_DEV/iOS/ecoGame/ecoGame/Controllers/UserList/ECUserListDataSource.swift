//
//  ECUserListDataSource.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 02/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit
import CoreData

protocol ECUsersDataSourceDelegate {
    func dataSource(ds:ECUsersDataSource, wantsToShowViewController vc:UIViewController)
}

class ECUsersDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIScrollViewDelegate, ECUserControllerDelegate {
    
    private var users: [ECUser]?
    private var query: String!
    private var delegate: ECUsersDataSourceDelegate?
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
    
    convenience init(withDelegate delegate:ECUsersDataSourceDelegate, andTableView tableView:UITableView) {
        self.init()
        
        self.query = ""
        self.delegate = delegate
        self.tableView = tableView
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.registerRequiredCells()
    }
    
    func registerRequiredCells() {
        self.tableView.ec_registerCell(ECUserListCell);
    }
    
    func fetchData() {
        // fetch data
        self.frc.ec_performFetch()
        self.reloadData()
    }
    
    private func reloadData() {
        let tempUsers:[ECUser] = (self.frc.fetchedObjects as? [ECUser])!
        defer {
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
        }
        
        guard self.query.characters.count > 0 else {
            self.users = tempUsers
            return
        }
        
        self.users = tempUsers.filter({
            $0.userName.lowercaseString.hasPrefix(self.query!)
        })
    }
    
    func addUser() {
        let userController: ECUserController = ECUserController.ec_createFromStoryboard() as! ECUserController
        userController.delegate = self
        self.delegate?.dataSource(self, wantsToShowViewController: userController)
    }
    
    func fetchWithQuery(query: String) {
        self.query = query
        self.reloadData()
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        UIApplication.sharedApplication().keyWindow!.endEditing(true)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users!.count;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ECUserListCell = tableView.dequeueReusableCellWithIdentifier(String(ECUserListCell), forIndexPath: indexPath) as! ECUserListCell
        
        cell.user = self.users![indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let userController: ECUserController = ECUserController.ec_createFromStoryboard() as! ECUserController
        userController.delegate = self
        userController.user = self.users![indexPath.row]
        self.delegate?.dataSource(self, wantsToShowViewController: userController)
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        dispatch_async(dispatch_get_main_queue()) {
            self.reloadData()
        };
    }
    
    // MARK: ECUserControllerDelegate
    func userController(uc:ECUserController, hasCreatedUser user:ECUser) {
        ECCoreManager.sharedInstance.storeManager.saveContext()
    }
    
    func userController(uc:ECUserController, hasUpdatedUser user:ECUser) {
        ECCoreManager.sharedInstance.storeManager.saveContext()
    }
    
    func userController(uc:ECUserController, hasDeletedUser user:ECUser) {
        ECCoreManager.sharedInstance.storeManager.saveContext()
    }
}