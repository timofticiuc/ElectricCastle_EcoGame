//
//  ECScore.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 26/06/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

class ECScore: NSObject {
    var score: Int = 0
    var metadata: String = ""
    var action: String = ""
    
    convenience init(dictionary: Dictionary<String, AnyObject>) {
        self.init()
        
        if let _score = dictionary["score"] {
            self.score = Int(_score.integerValue!)
        }
        
        if let _metadata = dictionary["metadata"] {
            self.metadata = String(_metadata)
        }
        
        if let _action = dictionary["action"] {
            self.action = String(_action)
        }
    }
}
