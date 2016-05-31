//
//  ECSeralizableObject.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 04/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import CoreData
import Foundation

class ECSeralizableObject: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var createdAt: NSDate

    private var _dictionaryRepresentation: Dictionary<String, AnyObject>?
    var dictionaryRepresentation: Dictionary<String, AnyObject>? {
        get {
            var userDict = Dictionary<String, AnyObject>()
            
            for (attr, _) in self.entity.attributesByName {
                guard let serializationKey = self.serializationKeyForAttribute(attr) else { continue }

                let value: AnyObject? = self.valueForKey(attr)
                
                if value == nil {
                    continue
                }
                
                if value!.isKindOfClass(NSNull) {
                    continue
                }
                
                userDict[serializationKey] = value
            }
            
            return userDict
        }
        set {
            _dictionaryRepresentation = newValue
            
            for (attr, _) in self.entity.attributesByName {
                guard let serializationKey = self.serializationKeyForAttribute(attr) else { continue }

                var value: AnyObject? = _dictionaryRepresentation![serializationKey as String]
                
                if value == nil {
                    value = _dictionaryRepresentation![attr as String]
                    if value == nil {
                        continue
                    }
                }
                
                if value!.isKindOfClass(NSNull) {
                    continue
                }
                
                value = self.serializationValueForAttribute(attr, andValue: value!)
                
                if value != nil {
                    self.setValue(value, forKey: attr as String)
                }
            }
        }
    }
    
    func serializationKeyForAttribute(attribute: String) -> String? {
        return attribute
    }
    
    func serializationValueForAttribute(attribute: String, andValue value:AnyObject) -> AnyObject? {
        return value
    }
    
    convenience init(objClass:AnyClass, inManagedObjectContext managedObjectContext: NSManagedObjectContext) {
        self.init(entity:NSEntityDescription.entityForName(String(objClass), inManagedObjectContext: managedObjectContext)!, insertIntoManagedObjectContext: managedObjectContext)
    }
    
    static func fetchRequestForObjectWithId(id: String) -> NSFetchRequest {
        let fetchRequest: NSFetchRequest = NSFetchRequest.init(entityName:String(self))
        fetchRequest.predicate = NSPredicate.init(format:"id == \"\(id)\"")
        fetchRequest.fetchLimit = 1
        
        return fetchRequest
    }
    
    static func objectWithIdentifier(identifier: String, fromContext context: NSManagedObjectContext) -> AnyObject? {
        guard let fr:NSFetchRequest = self.fetchRequestForObjectWithId(identifier) else { return nil }
        guard let obj = try! context.executeFetchRequest(fr).first else { return nil }
        
        return obj
    }
    
    static func objectCreatedOrUpdatedWithDictionary(dictionary: Dictionary<String, AnyObject>, inContext context:NSManagedObjectContext) -> AnyObject? {
        var result:ECSeralizableObject? = self.objectWithIdentifier(dictionary["id"] as! String, fromContext: context) as? ECSeralizableObject
        if result == nil {
            result = ECSeralizableObject.init(objClass:self, inManagedObjectContext:context)
            result!.createdAt = NSDate()
            result!.dictionaryRepresentation = dictionary
        }
        
        return result
    }
    
    func removeFromStore() {
        ECCoreManager.sharedInstance.storeManager.managedObjectContext?.deleteObject(self);
    }
}
