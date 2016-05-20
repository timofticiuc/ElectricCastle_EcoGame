//
//  ECCategory.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 04/05/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit
import CoreData

@objc(ECCategory)
class ECCategory: ECSeralizableObject {
    @NSManaged var categoryName: String
    @NSManaged private var level: Int32
    var userLevel:ECConstants.ECCategoryLevel {
        get { return ECConstants.ECCategoryLevel(rawValue: level) ?? .Beginner }
        set { level = newValue.rawValue }
    }
    @NSManaged private var type: Int32
    var categoryType:ECConstants.Category {
        get { return ECConstants.Category(rawValue: type) ?? .Energy }
        set { type = newValue.rawValue
            self.categoryName = newValue.ec_enumName()
        }
    }
    
    static func fetchRequestForCategories() -> NSFetchRequest {
        let fr: NSFetchRequest = NSFetchRequest(entityName: String(self))
        fr.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        return fr
    }
}
