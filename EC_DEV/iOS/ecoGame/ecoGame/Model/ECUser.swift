//
//  ECUser.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 02/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit
import CoreData

@objc(ECUser)
class ECUser: ECSeralizableObject {
    @NSManaged var userName: String
    @NSManaged var userPhone: String
    @NSManaged var createdAt: NSDate
    @NSManaged var role: Int32
    var userRole:ECUserRole {
        get { return ECUserRole(rawValue: self.role) ?? .ECUserRoleParticipant }
        set { self.role = newValue.rawValue }
    }
    
    static func fetchRequestForUsers() -> NSFetchRequest {
        let fr: NSFetchRequest = NSFetchRequest(entityName: String(self))
        fr.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        return fr
    }
}
