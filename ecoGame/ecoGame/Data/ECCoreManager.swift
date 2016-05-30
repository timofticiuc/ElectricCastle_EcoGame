//
//  ECCoreManager.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 03/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import Foundation

class ECCoreManager: NSObject {
    static let sharedInstance = ECCoreManager()
    
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
    }
    
    //MARK: - Request methods
    
    func getUsers() {
        self.requestManager.fetchUsersWithCompletion { (users) in
            for userObj in users {
                guard let userDict = userObj as? Dictionary<String, AnyObject> else { continue }
                var newUserDict = userDict
                newUserDict["id"] = userDict["user_unique_tag"]
                let user:ECUser = ECUser.objectCreatedOrUpdatedWithDictionary(newUserDict, inContext: self.storeManager.managedObjectContext!) as! ECUser
                if user.userCategories.count == 0 {
                    user.userCategories = user.defaultCategories()
                }
                
                NSLog("%@", user)
            }
            self.storeManager.saveContext()
        }
    }
}
