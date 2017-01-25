//
//  PostAPI.swift
//  Blocstagram
//
//  Created by ddenis on 1/24/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import Foundation
import Firebase


class PostAPI {
    
    var REF_POSTS = FIRDatabase.database().reference().child("posts")
    
    
    func observePosts(completion: @escaping (Post) -> Void) {
        REF_POSTS.observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            if let postDictionary = snapshot.value as? [String: Any] {
                
                let newPost = Post.transformPost(postDictionary: postDictionary, key: snapshot.key)
                
                completion(newPost)
            }
        }
    }
    
}
