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
    
    func updateView() {
        API.User.REF_CURRENT_USER?.observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot)
        })
    }
    
}
