//
//  Comment.swift
//  Blocstagram
//
//  Created by ddenis on 1/22/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import Foundation

class Comment {
    var commentText: String?
    var uid: String?
}

extension Comment {
    
    static func transformComment(postDictionary: [String: Any]) -> Comment  {
        let comment = Comment()
        
        comment.commentText = postDictionary["commentText"] as? String
        comment.uid = postDictionary["uid"] as? String
        
        return comment
    }
    
}
