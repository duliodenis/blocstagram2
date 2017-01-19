//
//  HomeTableViewCell.swift
//  Blocstagram
//
//  Created by ddenis on 1/17/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateView() {
        captionLabel.text = post?.caption
        if let photoURL = post?.photoURL {
            postImageView.sd_setImage(with: URL(string: photoURL))
        }
        
        updateUserInfo()
    }
    
    func updateUserInfo() {
        if let uid = post?.uid {
            FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { snapshot in
                if let postDictionary = snapshot.value as? [String: Any] {
                    
                    let user = User.transformUser(postDictionary: postDictionary)
                    self.nameLabel.text = user.username
                    
                    if let photoURL = user.profileImageURL {
                        self.profileImageView.sd_setImage(with: URL(string: photoURL))
                    }
                }
            })
        }
    }

}
