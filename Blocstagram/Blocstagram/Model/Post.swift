//
//  Post.swift
//  Blocstagram
//
//  Created by ddenis on 1/16/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import Foundation

class Post {
    var caption: String
    var photoURL: String
    
    init(caption: String, photoURL: String) {
        self.caption = caption
        self.photoURL = photoURL
    }
}
