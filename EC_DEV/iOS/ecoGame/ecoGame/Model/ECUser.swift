//
//  ECUser.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 02/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

@objc(ECUser)
class ECUser: ECSeralizableObject {
    var userName: String = ""
    var userPhone: String = ""
    var userRole: ECUserRole = .ECUserRoleParticipant
}
