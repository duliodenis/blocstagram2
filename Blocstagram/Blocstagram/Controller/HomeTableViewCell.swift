//
//  HomeTableViewCell.swift
//  Blocstagram
//
//  Created by ddenis on 1/17/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit
import FirebaseDatabase
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
    var postReference: FIRDatabaseReference!
    
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
        updateLike(post: post!)
        
        // observe like field to update if others like this post
        API.Post.REF_POSTS.child(post!.id!).observe(.childChanged, with: { snapshot in
            if let value = snapshot.value as? Int {
                self.likeCountButton.setTitle("\(value) Likes", for: .normal)
            }
        })
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
        postReference = API.Post.REF_POSTS.child(post!.id!)
        incrementLikes(forReference: postReference)
    }
    
    func incrementLikes(forReference ref: FIRDatabaseReference) {
        // Dealing with concurrent modifications based on:
        // https://firebase.google.com/docs/database/ios/read-and-write
        // Section: Save data as transactions
        ref.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = FIRAuth.auth()?.currentUser?.uid {
                var likes: Dictionary<String, Bool>
                likes = post["likes"] as? [String : Bool] ?? [:]
                var likeCount = post["likeCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    // Unlike the post and remove self from stars
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    // Like the post and add self to stars
                    likeCount += 1
                    likes[uid] = true
                }
                post["likeCount"] = likeCount as AnyObject?
                post["likes"] = likes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return FIRTransactionResult.success(withValue: currentData)
            }
            return FIRTransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let postDictionary = snapshot?.value as? [String:Any] {
                let post = Post.transformPost(postDictionary: postDictionary, key: snapshot!.key)
                self.updateLike(post: post)
            }
        }
    }
    
    func updateLike(post: Post) {
        let imageName = post.likes == nil || !post.isLiked! ? "like" : "likeSelected"
        likeImageView.image = UIImage(named: imageName)
        
        // display a message for Likes
        guard let count = post.likeCount else {
            return
        }
        
        if count != 0 {
            likeCountButton.setTitle("\(count) Likes", for: .normal)
        } else if post.likeCount == 0 {
            likeCountButton.setTitle("Be the first to Like this", for: .normal)
        }
    }

}
