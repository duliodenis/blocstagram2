//
//  ProfileViewController.swift
//  Blocstagram
//
//  Created by ddenis on 1/1/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit
// TODO: Refactor Model functionality out of the VC
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var user: User!
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        fetchUser()
        fetchMyPosts()
    }
    
    func fetchUser() {
        API.User.observeCurrentUser { user in
            self.user = user
            self.collectionView.reloadData()
        }
    }
    
    func fetchMyPosts() {
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            return
        }
        
        API.UserPost.REF_USER_POSTS.child(currentUser.uid).observe(.childAdded, with: { snapshot in
            API.Post.observePost(withID: snapshot.key, completion: {
                post in
                self.posts.append(post)
                self.collectionView.reloadData()
            })
        })
    }
}


extension ProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ProfileHeaderCollectionReusableView", for: indexPath) as! ProfileHeaderCollectionReusableView
        
        if let user = self.user {
            headerViewCell.user = user
        }
        
        return headerViewCell
    }
    
}
