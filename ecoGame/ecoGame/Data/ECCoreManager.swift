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
            return NSUserDefaults.standardUserDefaults().objectForKey(ECConstants.kCurrentSessionTimeStamp) as! NSDate
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: ECConstants.kCurrentSessionTimeStamp)
        }
    }
    var currentUser: ECUser? {
        get {
            guard let currentId = KeychainSwift().get(ECConstants.kCurrentUserId) else {return nil}
            return ECUser.objectWithIdentifier(currentId, fromContext: self.storeManager.managedObjectContext!) as? ECUser
        }
        set {
            guard let _=newValue else {
                KeychainSwift().delete(ECConstants.kCurrentUserId)
                return
            }
            KeychainSwift().set(newValue!.id, forKey: ECConstants.kCurrentUserId)
        }
    }

    override init() {
        storeManager = ECStoreManager()
        requestManager = ECRequestManager()
    }
    
}
