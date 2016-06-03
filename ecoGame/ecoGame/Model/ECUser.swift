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
    @NSManaged var userAddress: String
    @NSManaged var userEmail: String
    @NSManaged var userFirstName: String
    @NSManaged var userLastName: String
    @NSManaged var userPasswordHash: String
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
    
    override func serializationKeyForAttribute(attribute: String) -> String? {
        if attribute == "id" {
            return "user_unique_tag"
        } else if attribute == "role" {
            return "user_role"
        } else if attribute == "categories" {
            return "user_categories"
        } else if attribute == "userFirstName" {
            return "user_first_name"
        } else if attribute == "userLastName" {
            return "user_last_name"
        } else if attribute == "userAddress" {
            return "user_address"
        } else if attribute == "userEmail" {
            return "user_mail"
        } else if attribute == "userPasswordHash" {
            return "user_password_hash"
        } else if attribute == "userPhone" {
            return "user_phone"
        } else if attribute == "createdAt" {
            return nil
        }
        
        return attribute
    }
    
    override func serializationValueForAttribute(attribute: String, andValue value:AnyObject) -> AnyObject? {
        if attribute == "role" {
            let stringValue = value as! String
            
            return NSNumber(integer: Int(stringValue)!)
        }
        
        return value
    }
    
    func defaultCategories() -> [ECCategory] {
        let count = (ECCoreManager.sharedInstance.storeManager.managedObjectContext?.countForFetchRequest(ECCategory.fetchRequestForCategories(), error: nil))!
        
        var id = count
        let energyCategory:ECCategory = ECCategory.objectCreatedOrUpdatedWithDictionary(["id":"\(self.id)\(id)"], inContext: ECCoreManager.sharedInstance.storeManager.managedObjectContext!) as! ECCategory
        energyCategory.categoryType = .Energy
        energyCategory.categoryScores = energyCategory.defaultScores()
        
        id = count + 1
        let waterCategory:ECCategory = ECCategory.objectCreatedOrUpdatedWithDictionary(["id":"\(self.id)\(id)"], inContext: ECCoreManager.sharedInstance.storeManager.managedObjectContext!) as! ECCategory
        waterCategory.categoryType = .Water
        waterCategory.categoryScores = waterCategory.defaultScores()
        
        id = count + 2
        let transportCategory:ECCategory = ECCategory.objectCreatedOrUpdatedWithDictionary(["id":"\(self.id)\(id)"], inContext: ECCoreManager.sharedInstance.storeManager.managedObjectContext!) as! ECCategory
        transportCategory.categoryType = .Transport
        transportCategory.categoryScores = transportCategory.defaultScores()
        
        id = count + 3
        let wasteCategory:ECCategory = ECCategory.objectCreatedOrUpdatedWithDictionary(["id":"\(self.id)\(id)"], inContext: ECCoreManager.sharedInstance.storeManager.managedObjectContext!) as! ECCategory
        wasteCategory.categoryType = .Waste
        wasteCategory.categoryScores = wasteCategory.defaultScores()
        
        id = count + 4
        let socialCategory:ECCategory = ECCategory.objectCreatedOrUpdatedWithDictionary(["id":"\(self.id)\(id)"], inContext: ECCoreManager.sharedInstance.storeManager.managedObjectContext!) as! ECCategory
        socialCategory.categoryType = .Social
        socialCategory.categoryScores = socialCategory.defaultScores()
        
        return [energyCategory, wasteCategory, waterCategory, transportCategory, socialCategory]
    }
    
    static func fetchRequestForUsers() -> NSFetchRequest {
        let fr: NSFetchRequest = NSFetchRequest(entityName: String(self))
        fr.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        return fr
    }
}
