//
//  ECCategory.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 04/05/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

class ECCategory: ECSeralizableObject {
    @NSManaged private var level: Int32
    var userLevel:ECConstants.ECCategoryLevel {
        get { return ECConstants.ECCategoryLevel(rawValue: level) ?? .Beginner }
        set { level = newValue.rawValue }
    }
    
}
