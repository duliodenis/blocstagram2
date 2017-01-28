//
//  HomeTableViewCell.swift
//  Blocstagram
//
//  Created by ddenis on 1/17/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    var homeVC: HomeViewController?
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    var user: User? {
        didSet {
            updateUserInfo()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        captionLabel.text = ""
        
        // add a tap gesture to the comment image for users to segue to the commentVC
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCommentImageViewTap))
        commentImageView.addGestureRecognizer(tapGesture)
        commentImageView.isUserInteractionEnabled = true
        
        // add a tap gesture to the like image for users to like a post
        let likeTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLikeTap))
        likeImageView.addGestureRecognizer(likeTapGesture)
        likeImageView.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateView() {
        captionLabel.text = post?.caption
        if let photoURL = post?.photoURL {
            postImageView.sd_setImage(with: URL(string: photoURL))
        }
        
        // check to see if this post is liked
        if let currentUserID = API.User.CURRENT_USER_ID {
            API.User.REF_USERS.child(currentUserID).child("likes").child(post!.id!).observeSingleEvent(of: .value, with: { snapshot in
                if let _ = snapshot.value as? NSNull {
                    self.likeImageView.image = UIImage(named: "like")
                } else {
                    self.likeImageView.image = UIImage(named: "likeSelected")
                }
            })
        }
    }
    
    // flush the user profile image before a reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "profile")
    }
    
    // fetch the values from the user variable
    func updateUserInfo() {
        nameLabel.text = user?.username
        if let photoURL = user?.profileImageURL {
            profileImageView.sd_setImage(with: URL(string: photoURL), placeholderImage: UIImage(named: "profile"))
        }
    }
    
    
    // MARK: - Comment ImageView Segue
    
    func handleCommentImageViewTap() {
        if let id = post?.id {
            homeVC?.performSegue(withIdentifier: "CommentSegue", sender: id)
        }
    }
    
    
    // MARK: - Like Tap Handler
    
    func handleLikeTap() {
        if let currentUserID = API.User.CURRENT_USER_ID {
            API.User.REF_USERS.child(currentUserID).child("likes").child(post!.id!).observeSingleEvent(of: .value, with: { snapshot in
                if let _ = snapshot.value as? NSNull {
                    API.User.REF_USERS.child(currentUserID).child("likes").child(self.post!.id!).setValue(true)
                    self.likeImageView.image = UIImage(named: "likeSelected")
                } else {
                    API.User.REF_USERS.child(currentUserID).child("likes").child(self.post!.id!).removeValue()
                    self.likeImageView.image = UIImage(named: "like")
                }
            })
        }
    }

}
