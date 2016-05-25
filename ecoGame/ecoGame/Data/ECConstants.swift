//
//  ECConstants.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 02/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import Foundation

public enum ECUserRole: Int32 {
    case ECUserRoleParticipant = 0
    case ECUserRoleVolunteer
    case ECUserRoleAdmin
    
    func ec_enumName() -> String {
        switch self {
        case .ECUserRoleAdmin:
            return "Admin"
        case .ECUserRoleVolunteer:
            return "Volunteer"
        default:
            return "Participant"
        }
    }
}

let kCurrentUserId           = "kCurrentUserId"
let kCurrentSessionTimeStamp = "kCurrentSessionTimeStamp"
let kTitle                   = "title"
let kDescription             = "description"
let kScore                   = "score"

struct ECConstants {
    struct user {
        static let kUserName  = "user_name"
        static let kUserPhone = "user_phone"
        static let kUserId    = "user_id"
    }
    
    enum DirtyState: Int32 {
        case Create = 0
        case Delete
        case Update
    }
    
    enum Category: Int32 {
        case Energy = 0
        case Water
        case Transport
        case Social
        case Waste
        case Count
        
        func ec_enumName() -> String {
            switch self {
            case .Energy:
                return "Energy"
            case .Water:
                return "Water"
            case .Transport:
                return "Transport"
            case .Social:
                return "Social"
            case .Waste:
                return "Waste"
            default:
                return ""
            }
        }
    }
    
    enum ECCategoryLevel: Int32 {
        case Beginner = 0
        case Guardian
        case Angel
        case Legend
        
        func ec_enumName() -> String {
            switch self {
            case .Legend:
                return "Legend"
            case .Angel:
                return "Angel"
            case .Guardian:
                return "Guardian"
            default:
                return "Beginner :("
            }
        }
        
        func ec_value() -> NSNumber {
            return NSNumber(int: self.rawValue)
        }
    }
}