//
//  ECUser.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 02/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

class ECUser: NSObject {
    var userId: Int = -1
    var userName: String = ""
    var userPhone: String = ""
    var userRole: ECUserRole = .ECUserRoleParticipant
    
    convenience init(withDictionary dictionary: Dictionary<String, AnyObject>) {
        self.init()
        
        if let _userId = dictionary[ECConstants.user.kUserId] {
            self.userId = _userId.integerValue
        }
        
        if let _userName = dictionary[ECConstants.user.kUserName] {
            self.userName = _userName as! String
        }
        
        if let _userPhone = dictionary[ECConstants.user.kUserPhone] {
            self.userPhone = _userPhone as! String
        }
    }
}
