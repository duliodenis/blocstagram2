//
//  AuthService.swift
//  Blocstagram
//
//  Created by ddenis on 1/10/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import Firebase


class AuthService {
    
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        // Use Firebase Authentication with email and password
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError("Authentication Error: \(error!.localizedDescription)")
                return
            }
            onSuccess()
        })
    }
    
    
    static func signUp(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        // create a Firebase user
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user:FIRUser?, error: Error?) in
            if error != nil {
                onError("Create User Error: \(error!.localizedDescription)")
                return
            }
            
            let uid = user?.uid
            
            // get a reference to our file store
            let storeRef = FIRStorage.storage().reference(forURL: Constants.fileStoreURL).child("profile_image").child(uid!)
            
            storeRef.put(imageData, metadata: nil, completion: { (metaData, error) in
                if error != nil {
                    print("Profile Image Error: \(error?.localizedDescription)")
                    return
                }
                // if there's no error
                // get the URL of the profile image in the file store
                let profileImageURL = metaData?.downloadURL()?.absoluteString
                
                // set the user information with the profile image URL
                self.setUserInformation(profileImageURL: profileImageURL!, username: username, email: email, uid: uid!, onSuccess: onSuccess)
            })
            
        })
    }
    
    
    // MARK: - Firebase Saving Methods
    
    static func setUserInformation(profileImageURL: String, username: String, email: String, uid: String, onSuccess: @escaping () -> Void) {
        // create the new user in the user node and store username, email, and profile image URL
        let ref = FIRDatabase.database().reference()
        let userReference = ref.child("users")
        let newUserReference = userReference.child(uid)
        newUserReference.setValue(["username": username,
                                   "email": email,
                                   "profileImageURL": profileImageURL])
        onSuccess()
    }
    
}
