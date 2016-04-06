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
    var currentUser: ECUser?

    override init() {
        storeManager = ECStoreManager()
        requestManager = ECRequestManager()
    }
    
}
