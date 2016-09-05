//
//  ECCoreManager.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 03/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import Foundation
import ReachabilitySwift

class ECCoreManager: NSObject {
    static let sharedInstance = ECCoreManager()
    
    var reachabilityManager: Reachability?
    var storeManager: ECStoreManager
    var requestManager: ECRequestManager
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
        storeManager = ECStoreManager()
        requestManager = ECRequestManager()
        
        super.init()
        
        do {
            self.reachabilityManager = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        if let reachability = self.reachabilityManager {
            reachability.whenReachable = { reachability in
                self.sendDirtyUsers()
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
            let allUsers = try self.storeManager.managedObjectContext?.executeFetchRequest(ECUser.fetchRequestForUsers()) as! [ECUser]
            for user:ECUser in allUsers {
                if user.dirty {
                    if user.id.hasPrefix("temp_") {
                        self.createUser(user)
                    } else {
                        self.updateUser(user)
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
//            if user.userCategories.count == 0 {
//                user.userCategories = user.defaultCategories()
//            }
            
            NSLog("%@", user)
            completion(user: user)
        }
    }
    
    func getUsers() {
        self.requestManager.fetchUsersWithCompletion { (users) in
            for userObj in users {
                guard let userDict = userObj as? Dictionary<String, AnyObject> else { continue }
                var newUserDict = userDict
                newUserDict["id"] = userDict["user_unique_tag"]
                let user:ECUser = ECUser.objectCreatedOrUpdatedWithDictionary(newUserDict, inContext: self.storeManager.managedObjectContext!) as! ECUser
//                if user.userCategories.count == 0 {
//                    user.userCategories = user.defaultCategories()
//                }
                
                NSLog("%@", user)
            }
            self.storeManager.saveContext()
        }
    }
    
    func createUser(user: ECUser) {
        self.requestManager.createUser(user) { (userDict: Dictionary<String, AnyObject>?, success) in
            defer {
                user.rebindCategories()
                self.storeManager.saveContext()
//                for category:ECCategory in user.userCategories {
//                    self.requestManager.createCategory(category, withCompletion: { (success) in
//                        NSLog("%@", category)
//                        if success {
//                            category.dirty = false
//                            self.storeManager.saveContext()
//                        }
//                    })
//                }
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
//            for category:ECCategory in user.userCategories {
//                if category.dirty {
//                    self.requestManager.createCategory(category, withCompletion: { (success) in
//                        category.dirty = false
//                        self.storeManager.saveContext()
//                    })
//                } else {
//                    self.requestManager.updateCategory(category, withCompletion: { (success) in
//                        self.storeManager.saveContext()
//                    })
//                }
//            }
            if success {
                user.dirty = false
            }
        }
    }
    
    func deleteUser(user: ECUser, withCompletion completion: (success: Bool) -> Void) {
//        self.requestManager.deleteUser(user) { (success) in
//            completion(success: success);
//        }
    }
    
    //MARK: - Category Request methods

    func updateCategory(category: ECCategory) {
//        if category.dirty {
//            self.requestManager.createCategory(category, withCompletion: { (success) in
//                category.dirty = false
//                self.storeManager.saveContext()
//            })
//        } else {
//            self.requestManager.updateCategory(category, withCompletion: { (success) in
//                self.storeManager.saveContext()
//            })
//        }
    }
    
    func getCategoryForId(id: String, withCompletion completion: (category: ECCategory?) -> Void) {
//        self.requestManager.getCategoryForId(id) { (categoryDict: Dictionary<String, AnyObject>?) in
//            if categoryDict != nil {
//                var newCategDict = categoryDict
//                newCategDict!["id"] = categoryDict!["category_name"]
//                let category:ECCategory = ECCategory.objectCreatedOrUpdatedWithDictionary(newCategDict!, inContext: self.storeManager.managedObjectContext!) as! ECCategory
//                category.dictionaryRepresentation = newCategDict
//                completion(category: category)
//            }
//        }
    }
}
