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
    func dataSource(ds: ECUsersDataSource, hasChangedUserProgress userProgress: Int, count: Int)
    func dataSource(ds: ECUsersDataSource, hasChangedCategoryProgress categoryProgress: Int, count: Int)
    func dataSource(ds: ECUsersDataSource, hasFinishedFetchingData success: Bool)
}

class ECUsersDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIScrollViewDelegate, ECUserControllerDelegate {
    
    var users: [ECUser] = [ECUser]()
    private var query: String!
    private var userFilter: ECUserRole! = .ECUserRoleNone
    private var categoryFilter: ECConstants.Category! = ECConstants.Category.None
    private var userCategoryFilter: ECConstants.Category! = ECConstants.Category.None
    private var userCategoryFilterAscending: Bool = false
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
    
    var musicDrive: Bool = false
    var random: Bool = false {
        didSet {
            self.fetchData()
            self.reloadData()
            random = false
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
        if ECCoreManager.sharedInstance.currentUser?.userRole == .ECUserRoleVolunteer {
            self.userFilter = .ECUserRoleParticipant
        } else {
            self.userFilter = .ECUserRoleNone
        }
    }
    
    func registerRequiredCells() {
        self.tableView.ec_registerCell(ECUserListCell);
    }
    
    func fetchData() {
        // fetch data
        
        self.frc.ec_performFetch()
        self.users = (self.frc.fetchedObjects as? [ECUser])!
    }
    
    func optimizeUsersDataWithCompletion(completion: (success:Bool) -> Void,
                                         progressBlock: (progress:Int, count:Int) -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            for i in 0...self.users.count - 1 {
                let user = self.users[i]
                for category in user.userCategories {
                    category.category_scores = nil
                    category.overallScore()
                    category.scoreCompleteness()
                }
                progressBlock(progress: i, count:  self.users.count)
            }
            completion(success: true)
        }
    }
    
    func fetchRemoteData() {
        var usersMap = Dictionary<String, ECUser>()
        for user in self.users {
            usersMap[user.id] = user
        }
        
        ECCoreManager.sharedInstance.getUsersWithLocalUsers(usersMap, completion: { (success) in
                self.fetchData()
                self.reloadData()
                self.delegate?.dataSource(self, hasFinishedFetchingData: true)
            }, userProgressBlock: { (progress, count) in
                self.delegate?.dataSource(self, hasChangedUserProgress: progress, count: count)

            }) { (progress, count) in
                self.delegate?.dataSource(self, hasChangedCategoryProgress: progress, count: count)
        }
    }
    
    func reloadData() {
        var tempUsers:[ECUser] = self.users

//        for user in tempUsers {
//            NSLog("%@ %@", user.id, "temp_"+user.id)
//            user.id = "temp_"+user.id
//            for category:ECCategory in user.userCategories {
//                ECCoreManager.sharedInstance.requestManager.createCategory(category, withCompletion: { (success) in
//                    if success {
//                        category.dirty = false
//                    }
//                })
//            }
//        }
//        ECCoreManager.sharedInstance.storeManager.saveContext()
//        return
        
        defer {
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
        }
        
        let shouldFilterByName = (self.query.characters.count > 0)
        let shouldFilterByRole = (self.userFilter != .ECUserRoleNone)
        let shouldFilterByCategoryScore = (self.categoryFilter != ECConstants.Category.None)
        
        var filterCount = 0
        filterCount += shouldFilterByCategoryScore ? 1 : 0
        filterCount += shouldFilterByRole ? 1 : 0
        filterCount += shouldFilterByName ? 1 : 0

        
        if filterCount > 0 {
            tempUsers = tempUsers.filter({
                var validCount = 0
                if shouldFilterByName {
                    let isValidByName = ($0.userFirstName.lowercaseString.hasPrefix(self.query!) || $0.userLastName.lowercaseString.hasPrefix(self.query!))
                    validCount += isValidByName ? 1 : 0
                }
                
                if shouldFilterByRole {
                    let isValidByRole = ($0.userRole == self.userFilter)
                    validCount += isValidByRole ? 1 : 0
                }
                
                if shouldFilterByCategoryScore {
                    var isValidByCategoryScore = false
                    let categoryIndex = Int(self.categoryFilter.rawValue)
                    let score = $0.userCategories[categoryIndex].overallScore()
                    
                    isValidByCategoryScore = (score > 0)
                    
                    validCount += isValidByCategoryScore ? 1 : 0
                }
                
                return validCount == filterCount
            })
        }
        
        if self.userCategoryFilter != ECConstants.Category.None {
            tempUsers = tempUsers.sort({
                let categoryIndex = Int(self.userCategoryFilter.rawValue)

                let score1 = $0.userCategories[categoryIndex].overallScore()
                let score2 = $1.userCategories[categoryIndex].overallScore()
                
                
                if self.userCategoryFilterAscending {
                    return (score1 < score2)
                }
                return (score1 > score2)
            })
        }
        
        if self.musicDrive {
            tempUsers = tempUsers.filter({
                let category:ECCategory = $0.userCategories[Int(ECConstants.Category.Social.rawValue)] as ECCategory
                let musicScore = category.categoryScores[1].score
                return musicScore > 0
            })
        }
        
        if self.random {
            let randomIndex:Int = Int(arc4random()%UInt32(tempUsers.count))
            tempUsers = [tempUsers[randomIndex]]
        }
        
        self.users = tempUsers
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
    
    func applyUserFilter(userType: ECUserRole) {
        self.userFilter = userType
    }
    
    func applyCategoryFilter(categoryType: ECConstants.Category) {
        self.categoryFilter = categoryType
    }
    
    func applyCategorySort(categ: ECConstants.Category, ascending: Bool) {
        self.userCategoryFilterAscending = ascending
        self.userCategoryFilter = categ
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        UIApplication.sharedApplication().keyWindow!.endEditing(true)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ECUserListCell = tableView.dequeueReusableCellWithIdentifier(String(ECUserListCell), forIndexPath: indexPath) as! ECUserListCell
        
        cell.index = indexPath.row + 1
        cell.user = self.users[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cell = cell as! ECUserListCell
        cell.displayScores()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let userController: ECUserController = ECUserController.ec_createFromStoryboard() as! ECUserController
        userController.delegate = self
        userController.user = self.users[indexPath.row]
        self.delegate?.dataSource(self, wantsToShowViewController: userController)
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        dispatch_async(dispatch_get_main_queue()) {
            self.users = (self.frc.fetchedObjects as? [ECUser])!
            self.reloadData()
        };
    }
    
    // MARK: ECUserControllerDelegate
    func userController(uc:ECUserController, hasCreatedUser user:ECUser) {
        ECCoreManager.sharedInstance.createUser(user)
    }
    
    func userController(uc:ECUserController, hasUpdatedUser user:ECUser) {
        ECCoreManager.sharedInstance.updateUser(user)
    }
    
    func userController(uc:ECUserController, hasDeletedUser user:ECUser) {
        ECCoreManager.sharedInstance.deleteUser(user) { (success) in
            uc.navigationController?.popViewControllerAnimated(true)
        }
        user.removeFromStore()
        ECCoreManager.sharedInstance.storeManager.saveContext()
    }
}
