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
    @NSManaged private var role: Int32
    var userRole:ECUserRole {
        get { return ECUserRole(rawValue: role) ?? .ECUserRoleParticipant }
        set { role = newValue.rawValue }
    }
    
    @NSManaged private var categories: String
    var userCategories:[ECCategory]! {
        get {
            var tempCategories:[ECCategory] = [ECCategory]()
            if categories.characters.count == 0 {
                return []
            }
            let categoryIds = categories.componentsSeparatedByString(",")
            for categoryId in categoryIds {
                let persistedCategory = ECCategory.objectWithIdentifier(categoryId, fromContext: ECCoreManager.sharedInstance.storeManager.managedObjectContext!)
                tempCategories.append(persistedCategory as! ECCategory)
            }
            
            return tempCategories
        }
        set {
            var tempCategs = ""
            for category:ECCategory in newValue! {
                tempCategs += category.id
                if newValue?.last != category {
                    tempCategs += ","
                }
            }
            self.categories = tempCategs
        }
    }
        
    static func fetchRequestForUsers() -> NSFetchRequest {
        let fr: NSFetchRequest = NSFetchRequest(entityName: String(self))
        fr.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        return fr
    }
}
