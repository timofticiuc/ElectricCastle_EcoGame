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
    
    convenience init(dictionary: Dictionary<String, AnyObject>) {
        self.init()
        
        guard let _score = dictionary["score"] else { return }
        self.score = Int(_score.integerValue!)
        
        guard let _metadata = dictionary["metadata"] else { return }
        self.metadata = String(_metadata)
    }
}
