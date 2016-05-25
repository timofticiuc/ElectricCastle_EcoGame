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
    
}
