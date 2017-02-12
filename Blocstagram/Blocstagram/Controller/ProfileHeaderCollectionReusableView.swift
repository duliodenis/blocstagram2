//
//  ProfileHeaderCollectionReusableView.swift
//  Blocstagram
//
//  Created by Dulio Denis on 1/31/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    func updateView() {
        API.User.REF_CURRENT_USER?.observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot)
            
            if let userDictionary = snapshot.value as? [String: Any] {
                let user = User.transformUser(postDictionary: userDictionary)
                
                self.nameLabel.text = user.username
                
                if let photoURL = user.profileImageURL {
                    self.profileImageView.sd_setImage(with: URL(string: photoURL))
                }
            }
        })
    }
    
}
