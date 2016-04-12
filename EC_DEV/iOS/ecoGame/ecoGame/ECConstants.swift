//
//  ECConstants.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 02/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

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

struct ECConstants {
    struct user {
        static let kUserName = "user_name"
        static let kUserPhone = "user_phone"
        static let kUserId = "user_id"
    }
    
    static let kCurrentUserId = "kCurrentUserId"
    static let kCurrentSessionTimeStamp = "kCurrentSessionTimeStamp"

}