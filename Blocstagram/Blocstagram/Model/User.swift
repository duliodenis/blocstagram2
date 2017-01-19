//
//  User.swift
//  Blocstagram
//
//  Created by ddenis on 1/18/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import Foundation

class User {
    var email: String?
    var profileImageURL: String?
    var username: String?
}

extension User {
    
    static func transformUser(postDictionary: [String: Any]) -> User {
        let user = User()
        
        user.email = postDictionary["email"] as? String
        user.profileImageURL = postDictionary["profileImageURL"] as? String
        user.username = postDictionary["username"] as? String
        
        return user
    }
    
}
