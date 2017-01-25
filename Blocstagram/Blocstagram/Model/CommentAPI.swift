//
//  CommentAPI.swift
//  Blocstagram
//
//  Created by ddenis on 1/24/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import Foundation
import Firebase


class CommentAPI {
    
    var REF_COMMENTS = FIRDatabase.database().reference().child("comments")
    
    
    func observeComments(withPostID id: String, completion: @escaping (Comment) -> Void) {
        REF_COMMENTS.child(id).observeSingleEvent(of: .value, with: { snapshot in
                if let commentDictionary = snapshot.value as? [String: Any] {
                    
                    let newComment = Comment.transformComment(postDictionary: commentDictionary)
                    
                    completion(newComment)
                }
            })
        }
    
}
