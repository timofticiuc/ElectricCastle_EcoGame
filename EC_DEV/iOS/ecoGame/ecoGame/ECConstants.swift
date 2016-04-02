//
//  ECConstants.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 02/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

public enum ECUserRole {
    case ECUserRoleAdmin
    case ECUserRoleVolunteer
    case ECUserRoleParticipant
}

struct ECConstants {
    struct user {
        static let kUserName = "user_name"
        static let kUserPhone = "user_phone"
        static let kUserId = "user_id"
    }
}
