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
    
    override init() {
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }

    func fetchUsersWithCompletion(completion: (users:[AnyObject]) -> Void) {
        let url = self.baseUrl+"/users"
        
        self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask?, responseObject: AnyObject?) in
            guard let responseDict = responseObject as? Dictionary<String, AnyObject> else { completion(users: []); return }
            guard let usersArray = responseDict["data"] as? [AnyObject] else { completion(users: []); return }
            completion(users: usersArray)
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            let status = task?.response as! NSHTTPURLResponse
            if status == 200 {
                completion(users: [])
            }
        }
    }
    
    func createUser(user:ECUser, withCompletion completion: (success: Bool) -> Void) {
        let url = self.baseUrl+"/user"

        NSLog("%@", user.dictionaryRepresentation!)
        self.manager.POST(url, parameters: user.dictionaryRepresentation, progress: nil, success: { (task: NSURLSessionDataTask?, responseObject: AnyObject?) in
            guard let responseDict = responseObject as? Dictionary<String, AnyObject> else { return }
            NSLog("%@", responseDict)
            let status = task?.response as! NSHTTPURLResponse
            if status.statusCode == 200 {
                completion(success: true)
            }
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            let status = task?.response as! NSHTTPURLResponse
            if status == 200 {
                completion(success: false)
            }
        }
    }
    
    func updateUser(user:ECUser, withCompletion completion: (success: Bool) -> Void) {
        let url = self.baseUrl+"/user/"+user.id
        
        NSLog("%@", user.dictionaryRepresentation!)
        self.manager.PUT(url, parameters: user.dictionaryRepresentation, success: { (task: NSURLSessionDataTask?, responseObject: AnyObject?) in
            guard let responseDict = responseObject as? Dictionary<String, AnyObject> else { return }
            NSLog("%@", responseDict)
            let status = task?.response as! NSHTTPURLResponse
            if status.statusCode == 200 {
                completion(success: true)
            }
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            let status = task?.response as! NSHTTPURLResponse
            if status == 200 {
                completion(success: false)
            }
        }
    }
    
    func deleteUser(user:ECUser, withCompletion completion: (success: Bool) -> Void) {
        let url = self.baseUrl+"/user/"+user.id
        
        self.manager.DELETE(url, parameters: nil, success: { (task: NSURLSessionDataTask?, responseObject: AnyObject?) in
            guard let responseDict = responseObject as? Dictionary<String, AnyObject> else { return }
            NSLog("%@", responseDict)
            let status = task?.response as! NSHTTPURLResponse
            if status.statusCode == 200 {
                completion(success: true)
            }
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            let status = task?.response as! NSHTTPURLResponse
            if status == 200 {
                completion(success: false)
            }
        }
    }
}
