//
//  ECConstants.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 02/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

public enum ECUserRole: Int {
    case ECUserRoleAdmin = 0
    case ECUserRoleVolunteer
    case ECUserRoleParticipant
    
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
}
