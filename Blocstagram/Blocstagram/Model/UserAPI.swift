//
//  UserAPI.swift
//  Blocstagram
//
//  Created by ddenis on 1/24/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth


class UserAPI {
    
    var REF_USERS = FIRDatabase.database().reference().child("users")
    var CURRENT_USER = FIRAuth.auth()?.currentUser
    var CURRENT_USER_ID = FIRAuth.auth()?.currentUser?.uid
    
    func observeUser(withID uid:String, completion: @escaping (User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value, with: { snapshot in
            if let postDictionary = snapshot.value as? [String: Any] {
                let user = User.transformUser(postDictionary: postDictionary)
                completion(user)
            }
        })
    }

}
