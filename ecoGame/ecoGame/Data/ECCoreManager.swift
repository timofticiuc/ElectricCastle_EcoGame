//
//  ECCoreManager.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 03/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import Foundation
import CoreData

class ECCoreManager: NSObject {
    static let sharedInstance = ECCoreManager()
    var canSend: Bool = false
    
    var bgMOC: NSManagedObjectContext!
    var reachabilityManager: Reachability?
    var storeManager: ECStoreManager!
    var requestManager: ECRequestManager!
    var currentSessionTimeStamp: NSDate {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(kCurrentSessionTimeStamp) as! NSDate
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: kCurrentSessionTimeStamp)
        }
    }
    var currentUser: ECUser? {
        get {
            guard let currentId = KeychainSwift().get(kCurrentUserId) else {return nil}
            return ECUser.objectWithIdentifier(currentId, fromContext: self.storeManager.managedObjectContext!) as? ECUser
        }
        set {
            guard let _=newValue else {
                KeychainSwift().delete(kCurrentUserId)
                return
            }
            KeychainSwift().set(newValue!.id, forKey: kCurrentUserId)
        }
    }
    
    override init() {
        super.init()

        self.storeManager = ECStoreManager()
        self.requestManager = ECRequestManager()
        
        do {
            self.reachabilityManager = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        if let reachability = self.reachabilityManager {
            reachability.whenReachable = { reachability in
                if self.canSend {
                    self.canSend = false
                    self.sendDirtyUsers()
                }
            }
            
            reachability.whenUnreachable = { reachability in
                self.canSend = true
            }
            
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
    }
    
    //MARK: - Send dirty users when in wifi
    
    func sendDirtyUsers() {
        do {
            var count = 0
            let allUsers = try self.storeManager.managedObjectContext?.executeFetchRequest(ECUser.fetchRequestForUsers()) as! [ECUser]
            for user:ECUser in allUsers {
                if user.dirty {
                    if user.id.hasPrefix("temp_") {
                        self.createUser(user)
                    } else {
                        self.updateUser(user)
                    }
                }
                
                var categCount = 0
                
                for category:ECCategory in user.userCategories {
                    if category.dirty {
                        self.requestManager.updateCategory(category, withCompletion: { (success) in
                            if success {
                                category.dirty = false
                            }
                            categCount += 1
                            if categCount == 5 {
                                count += 1
                            }
                            
                            if count == allUsers.count {
                                self.storeManager.saveContext()
                            }
                        })
                    }
                }
            }
        } catch {
        }
    }
    
    //MARK: - User Request methods
    
    func loginWithCredentials(userIdentifier: String, andPasswordHash passwordHash:String, withCompletion completion: (user: ECUser?) -> Void) {
        self.requestManager.loginWithCredentials(userIdentifier, andPasswordHash: passwordHash) { (userDictionary) in
            if userDictionary == nil {
                completion(user: nil)
                return
            }
            
            var newUserDict = userDictionary!
            newUserDict["id"] = userDictionary!["user_unique_tag"]
            let user:ECUser = ECUser.objectCreatedOrUpdatedWithDictionary(newUserDict, inContext: self.storeManager.managedObjectContext!) as! ECUser
            if user.userCategories.count == 0 {
                user.userCategories = user.defaultCategories()
            }
            
            NSLog("%@", user)
            completion(user: user)
        }
    }
    
    var fetchCompletion: ((Bool) -> Void)!
    func bgMOCDidSave(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue()) { 
            self.storeManager.managedObjectContext?.mergeChangesFromContextDidSaveNotification(notification)
            NSNotificationCenter.defaultCenter().removeObserver(self)
            self.fetchCompletion(true)
        }
    }
    
    func getUsersWithLocalUsers(localUsers: Dictionary<String, ECUser>,
                                completion: (success:Bool) -> Void,
                                userProgressBlock: (progress:Int, count:Int) -> Void,
                                categoryProgressBlock: (progress:Int, count:Int) -> Void) {
        self.fetchCompletion = completion
        self.requestManager.fetchUsersWithCompletion { (users) in
            self.bgMOC = NSManagedObjectContext()
            self.bgMOC.persistentStoreCoordinator = self.storeManager.managedObjectContext!.persistentStoreCoordinator
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.bgMOCDidSave), name: NSManagedObjectContextDidSaveNotification, object: self.bgMOC)

            var lUsers = localUsers
            var userIndex = 0
            var userCategCount = 0
            
            for userObj in users {
                userIndex += 1
                guard let userDict = userObj as? Dictionary<String, AnyObject> else { continue }
                var newUserDict = userDict
                newUserDict["id"] = userDict["user_unique_tag"]
                let user:ECUser = ECUser.objectCreatedOrUpdatedWithDictionary(newUserDict, inContext: self.bgMOC) as! ECUser
                if user.userCategoriesForMOC(self.bgMOC).count == 0 {
                    user.userCategories = user.defaultCategoriesWithMOC(self.bgMOC)
                }
                lUsers.removeValueForKey(user.id)
                
                for categ in user.userCategoriesForMOC(self.bgMOC) {
                    self.requestManager.getCategoryForId(categ.id) { (categoryDict: Dictionary<String, AnyObject>?) in
                        if categoryDict != nil {
                            var newCategDict = categoryDict
                            newCategDict!["id"] = categoryDict!["category_name"]
                            let category:ECCategory = ECCategory.objectCreatedOrUpdatedWithDictionary(newCategDict!, inContext: self.bgMOC) as! ECCategory
                            category.dictionaryRepresentation = newCategDict
                            category.category_scores = nil
                            category.overallScore()
                            category.scoreCompleteness()
                        } else {
                            categ.category_scores = nil
                            categ.overallScore()
                            categ.scoreCompleteness()
                        }
                        
                        userCategCount += 1
                        NSLog("userCategCount: %d / %d", userCategCount/5, users.count)
                        
                        categoryProgressBlock(progress: userCategCount/5, count: users.count)
                        
                        if userCategCount == users.count*5 {
                            do {
                                try self.bgMOC.save()
                            } catch { }
                        }
                    }
                }
                
                userProgressBlock(progress: userIndex + 1, count: users.count)
            }
            
            //we chech what users are left out. that means they were deleted server side and should be removed form the db
            if lUsers.count > 0 {
                for user in lUsers.values {
                    user.removeFromStore()
                }
                self.storeManager.saveContext()
            }
        }
    }
    
    func createUser(user: ECUser) {
        self.requestManager.createUser(user) { (userDict: Dictionary<String, AnyObject>?, success) in
            defer {
                user.rebindCategories()
                self.storeManager.saveContext()
                for category:ECCategory in user.userCategories {
                    self.requestManager.createCategory(category, withCompletion: { (success) in
                        if success {
                            category.dirty = false
                            self.storeManager.saveContext()
                        }
                    })
                }
            }
            
            if userDict == nil {
                return
            }
            
            guard let user_tag = userDict!["user_unique_tag"] as? String else { return }
            
            user.dirty = false
            user.id = user_tag
        }
    }
    
    func updateUser(user: ECUser) {
        self.requestManager.updateUser(user) { (success) in
            for category:ECCategory in user.userCategories {
                if category.dirty {
                    self.requestManager.updateCategory(category, withCompletion: { (success) in
                        if success {
                            category.dirty = false
                            self.storeManager.saveContext()
                        }
                    })
                }
            }
            if success {
                user.dirty = false
            }
            self.storeManager.saveContext()
        }
    }
    
    func deleteUser(user: ECUser, withCompletion completion: (success: Bool) -> Void) {
        self.requestManager.deleteUser(user) { (success) in
            completion(success: success);
        }
    }
    
    //MARK: - Category Request methods
    
    func updateCategory(category: ECCategory) {
        self.requestManager.updateCategory(category, withCompletion: { (success) in
            if success {
                category.dirty = false
                self.storeManager.saveContext()
            }
        })
    }
    
    func getCategoryForId(id: String, withCompletion completion: (category: ECCategory?) -> Void) {
        self.requestManager.getCategoryForId(id) { (categoryDict: Dictionary<String, AnyObject>?) in
            if categoryDict != nil {
                var newCategDict = categoryDict
                newCategDict!["id"] = categoryDict!["category_name"]
                let category:ECCategory = ECCategory.objectCreatedOrUpdatedWithDictionary(newCategDict!, inContext: self.storeManager.managedObjectContext!) as! ECCategory
                category.dictionaryRepresentation = newCategDict
                completion(category: category)
            } else {
                completion(category: nil)
            }
        }
    }
}
