//
//  ECRequestManager.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 04/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import Foundation
import AFNetworking

class ECRequestManager: NSObject {
    let manager:AFHTTPSessionManager = AFHTTPSessionManager(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
    let baseUrl = "http://www.mainoi.ro/service/api.php"
    let bgQueue: dispatch_queue_t!
    
    override init() {
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let queueAttrs: dispatch_queue_attr_t = dispatch_queue_attr_make_with_qos_class(
            DISPATCH_QUEUE_SERIAL,
            QOS_CLASS_USER_INITIATED /* Same as DISPATCH_QUEUE_PRIORITY_HIGH */,
            0
        )
        bgQueue = dispatch_queue_create("com.timo.ecgame", queueAttrs)
    }

    func fetchUsersWithCompletion(completion: (users:[AnyObject]) -> Void) {
        let url = self.baseUrl+"/users"
        
        self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask?, responseObject: AnyObject?) in
            guard let responseDict = responseObject as? Dictionary<String, AnyObject> else { completion(users: []); return }
            guard let usersArray = responseDict["data"] as? [AnyObject] else { completion(users: []); return }
            dispatch_async(self.bgQueue) {
                completion(users: usersArray)
            }
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            completion(users: [])
        }
    }
    
    func createUser(user:ECUser, withCompletion completion: (userDict:Dictionary<String, AnyObject>?, success: Bool) -> Void) {
        let url = self.baseUrl+"/user"

        NSLog("%@", user.dictionaryRepresentation!)
        self.manager.POST(url, parameters: user.dictionaryRepresentation, progress: nil, success: { (task: NSURLSessionDataTask?, responseObject: AnyObject?) in
            guard let responseDict = responseObject as? Dictionary<String, AnyObject> else { completion(userDict:nil, success: false); return }
            guard let userDict = responseDict["data"] as? Dictionary<String, AnyObject> else { completion(userDict:nil, success: false); return }
            NSLog("%@", responseDict)
            let status = task?.response as! NSHTTPURLResponse
            if status.statusCode == 200 {
                completion(userDict: userDict, success: true)
            } else {
                completion(userDict: nil, success: false)
            }
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            completion(userDict:nil, success: false)
        }
    }
    
    func updateUser(user:ECUser, withCompletion completion: (success: Bool) -> Void) {
        let url = self.baseUrl+"/user/"+user.id
        
        NSLog("%@", user.dictionaryRepresentation!)
        self.manager.PUT(url, parameters: user.dictionaryRepresentation, success: { (task: NSURLSessionDataTask?, responseObject: AnyObject?) in
            guard let responseDict = responseObject as? Dictionary<String, AnyObject> else { completion(success: false); return }
            NSLog("%@", responseDict)
            let status = task?.response as! NSHTTPURLResponse
            if status.statusCode == 200 {
                completion(success: true)
            } else {
                completion(success: false)
            }
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            completion(success: false)
        }
    }
    
    func deleteUser(user:ECUser, withCompletion completion: (success: Bool) -> Void) {
        let url = self.baseUrl+"/user/"+user.id
        
        self.manager.DELETE(url, parameters: nil, success: { (task: NSURLSessionDataTask?, responseObject: AnyObject?) in
            guard let responseDict = responseObject as? Dictionary<String, AnyObject> else { completion(success: false); return }
            NSLog("%@", responseDict)
            let status = task?.response as! NSHTTPURLResponse
            if status.statusCode == 200 {
                completion(success: true)
            }
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            completion(success: false)
        }
    }
    
    func loginWithCredentials(userIdentifier: String, andPasswordHash passwordHash:String, withCompletion completion: (userDictionary: Dictionary<String, AnyObject>?) -> Void) {
        let url = "http://www.mainoi.ro/service/login_api.php/login"
        
        let bodyDict = ["login_identifier":userIdentifier,
                        "login_password_hash":passwordHash]
        self.manager.POST(url, parameters: bodyDict, progress: nil, success: { (task: NSURLSessionDataTask?, responseObject: AnyObject?) in
            guard let responseDict = responseObject as? Dictionary<String, AnyObject> else { completion(userDictionary: nil); return }
            guard let userDict = responseDict["data"] as? Dictionary<String, AnyObject> else { completion(userDictionary: nil); return }

            NSLog("%@", responseDict)
            let status = task?.response as! NSHTTPURLResponse
            if status.statusCode == 200 {
                completion(userDictionary: userDict)
            } else {
                completion(userDictionary: nil)
            }
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            completion(userDictionary: nil)
        }
    }
    
    //MARK: - Categories
    
    func createCategory(category:ECCategory, withCompletion completion: (success: Bool) -> Void) {
        let url = self.baseUrl+"/category"
        
        NSLog("%@", category.dictionaryRepresentation!)
        self.manager.POST(url, parameters: category.dictionaryRepresentation, progress: nil, success: { (task: NSURLSessionDataTask?, responseObject: AnyObject?) in
            guard let responseDict = responseObject as? Dictionary<String, AnyObject> else { completion(success: false); return }
            NSLog("%@", responseDict)
            let status = task?.response as! NSHTTPURLResponse
            if status.statusCode == 200 {
                completion(success: true)
            } else {
                completion(success: false)
            }
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            completion(success: false)
        }
    }
    
    func updateCategory(category:ECCategory, withCompletion completion: (success: Bool) -> Void) {
        let url = self.baseUrl+"/category/"+category.id
        
        NSLog("%@", category.dictionaryRepresentation!)
        self.manager.PUT(url, parameters: category.dictionaryRepresentation, success: { (task: NSURLSessionDataTask?, responseObject: AnyObject?) in
            guard let responseDict = responseObject as? Dictionary<String, AnyObject> else { completion(success: false); return }
            NSLog("%@", responseDict)
            let status = task?.response as! NSHTTPURLResponse
            if status.statusCode == 200 {
                completion(success: true)
            } else {
                completion(success: false)
            }
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            completion(success: false)
        }
    }
    
    func getCategoryForId(id: String, withCompletion completion: (categoryDict: Dictionary<String, AnyObject>?) -> Void) {
        let url = self.baseUrl+"/category/"+id
        
        self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask?, responseObject: AnyObject?) in
            guard let responseDict = responseObject as? Dictionary<String, AnyObject> else { completion(categoryDict: nil); return }
            NSLog("%@", responseDict)
            guard let categoryDict = responseDict["data"] as? Dictionary<String, AnyObject> else { completion(categoryDict: nil); return }
            NSLog("%@", categoryDict)
            let status = task?.response as! NSHTTPURLResponse
            dispatch_async(self.bgQueue) {
                if status.statusCode == 200 {
                    completion(categoryDict: categoryDict)
                } else {
                    completion(categoryDict: nil)
                }
            }
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            completion(categoryDict: nil)
        }
    }
}
